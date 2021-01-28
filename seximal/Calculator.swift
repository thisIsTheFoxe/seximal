//
//  Calculator.swift
//  seximal
//
//  Created by Henrik Storch on 27.01.21.
//

import Foundation
import SwiftUI

class Calculator: ObservableObject {
    
    enum Action: CalculatorAction, CaseIterable {
        case op(_ op: CalculatorOp), mod(_ mod: CalculatorModifier), clear, equal
        
        static var allCases: [Action] = [
            .mod(.number(i: 0)),    .mod(.number(i: 1)),    .mod(.comma),
            .mod(.number(i: 2)),    .mod(.number(i: 3)),    .clear,
            .mod(.number(i: 4)),    .mod(.number(i: 5)),    .mod(.del),
            .op(.plus),             .op(.minus),            .equal,
            .op(.mult),             .op(.div),              .mod(.negate),
            .mod(.pow),             .mod(.sqrt),            .mod(.rand),
        ]
        
        var id: Action { return self }
        
        var sfSymbolName: String? {
            switch self {
            case .op(let op):
                return op.sfSymbolName
            case .mod(let mod):
                return mod.sfSymbolName
            case .equal:
                return "equal"

            default:
                return nil
            }
        }
        
        var displayName: String {
            switch self {
            case .op(let op):
                return op.displayName
            case .mod(let mod):
                return mod.displayName
            case .clear:
                return "AC"
            case .equal:
                return "="
            default:
                return "?"
            }
        }
        
        var backgoundColor: Color {
            switch self {
            case .mod(let mod):
                return mod.backgoundColor
            case .op(_):
                return .orange
            default:
                return Color.gray.opacity(0.125)
            }
        }
    }
    
    
    @Published var logic: CalculatorLogic = .left("0")
    var temporaryKept: [Action] = []
    
    func apply(_ item: Action) {
        logic = logic.apply(item: item)
        temporaryKept.removeAll()
    }
}



enum CalculatorLogic {
    case left(String)
    case leftOp(left: String, op: CalculatorOp)
    case leftOpRight(left: String, op: CalculatorOp, right: String)
    case error
    
    var output: String {
        var result: String
        switch self {
        case .left(let left): result = left
        case .leftOp(let left, _): result = left
        case .leftOpRight(_, _, let right): result = right
        case .error: return "Error"
        }
        
        guard let _ = Double(result, radix: 6) else {
            return "Error"
        }
                
        if let grSeperator = Locale.current.groupingSeparator, let decSeperator = Locale.current.decimalSeparator {
            let parts = result.components(separatedBy: decSeperator)
            if let int = parts.first, int.count >= 5, parts.count <= 2 {
                let rest = parts.count == 2 ? decSeperator + parts[1] : ""
                result = parts[0].split(by: 4).joined(separator: grSeperator) + rest
            }
        }
        
        if result.containsDecSperator && !result.containsDecSperator {
            result = result.applyDecSeperator()
        }
        
        return result
    }
    
    @discardableResult
    func apply(item: Calculator.Action) -> CalculatorLogic  {
        switch item {
        case .op(let op):
            return apply(op)
        case .mod(mod: let mod):
            return apply(mod)
        case .clear:
            return .left("0")
        case .equal:
            return applyEqual()
        }
    }
    
    private func apply(_ op: CalculatorOp) -> CalculatorLogic {
        switch self {
        case .left(let left):
            return .leftOp(left: left, op: op)
        case .leftOp(left: let left, op: _):
            return .leftOp(left: left, op: op)
        case .leftOpRight(left: let left, op: let currentOp, right: let right):
            guard let result = currentOp.calculate(l: left, r: right) else { return .error }
            return .leftOp(left: result, op: op)
        case .error:
            return self
        }
    }
    
    private func apply(_ mod: CalculatorModifier) -> CalculatorLogic {
        switch self {
        case .left(let left):
            guard let result = mod.modify(text: left) else { return .error }
            return .left(result)
        case .leftOp(left: let left, op: let op):
            guard let result = mod.modify(text: "0") else { return .error }
            return .leftOpRight(left: left, op: op, right: result)
        case .leftOpRight(left: let left, op: let op, right: let right):
            guard let result = mod.modify(text: right) else { return .error }
            return .leftOpRight(left: left, op: op, right: result)
        case .error:
            guard let result = mod.modify(text: "0") else { return .error }
            return .left(result)
        }
    }
    
    private func applyEqual() -> CalculatorLogic {
        switch self {
        case .leftOp(left: let left, op: let op):
            guard let result = op.calculate(l: left, r: left) else { return .error }
            return .leftOp(left: result, op: op)
        case .leftOpRight(left: let left, op: let op, right: let right):
            guard let result = op.calculate(l: left, r: right) else { return .error }
            return .left(result)
        default:
            return self
        }
    }
}

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    var containsDecSperator: Bool {
        return contains(Locale.current.decimalSeparator ?? "")
    }

    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    func negate() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }

    func deletingLast() -> String {
        var result = self
        if result != "0" {
            _ = result.popLast()
        }
        return result.isEmpty ? "0" : result
    }
    
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }

    func applyDecSeperator() -> String {
        return containsDecSperator ? self : self + (Locale.current.decimalSeparator ?? ".")
    }

    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
}
