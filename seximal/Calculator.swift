//
//  Calculator.swift
//  seximal
//
//  Created by Henrik Storch on 27.01.21.
//

import Foundation

class Calculator: ObservableObject {
    @Published var logic: CalculatorLogic = .left("0")
    var temporaryKept: [CalculatorOperation] = []
    
    func apply(_ item: CalculatorOperation) {
        logic = logic.apply(item: item)
        temporaryKept.removeAll()
    }
}



enum CalculatorLogic {
    case left(String)
    case leftOp(left: String, op: CalculatorOperation)
    case leftOpRight(left: String, op: CalculatorOperation, right: String)
    case error

    @discardableResult
    func apply(item: CalculatorOperation) -> CalculatorLogic {
        switch item {
        case .number(let num):
            return apply(num: num)
        case .comma:
            return applyDot()
        case .clear:
            return applyClear()
        case .del:
            return applyDel()
        case .negate:
            return negate()
        case .rand:
            return applyRand()
        default:
            return apply(op: item)
//        case .command(let command):
//            return apply(command: command)
        }
    }

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
            result = result.applyDot()
        }
        
        return result
    }

    private func apply(num: Int) -> CalculatorLogic {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }

    private func applyRand() -> CalculatorLogic {
        switch self {
        case .left:
            return .left(String(Double.random(in: 0...1), radix: 6))
        case .leftOp(left: _, op: let op):
            return .leftOp(left: String(Double.random(in: 0...1), radix: 6), op: op)
        case .leftOpRight(left: let left, op: let op, right: _):
            return .leftOpRight(left: left, op: op, right: String(Double.random(in: 0...1), radix: 6))
        case .error:
            return self
        }
    }
    
    private func negate() -> CalculatorLogic {
        switch self {
        case .left(let left):
            return .left(left.negate())
        case .leftOp(let left, let op):
            return .leftOp(left: left.negate(), op: op)
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.negate())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    private func applyDot() -> CalculatorLogic {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    private func applyClear() -> CalculatorLogic {
        return .left("0")
    }
    
    private func applyDel() -> CalculatorLogic {
        switch self {
        case .left(let left):
            return .left(left.deletingLast())
        case .leftOp(left: let left, op: let op):
            return .leftOp(left: left.deletingLast(), op: op)
        case .leftOpRight(left: let left, op: let op, right: let right):
            return .leftOpRight(left: left, op: op, right: right.deletingLast())
        case .error:
            return self
        }
    }

    private func apply(op: CalculatorOperation) -> CalculatorLogic {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .mult, .div:
                return .leftOp(left: left, op: op)
            case .pow, .sqrt:
                guard let result = op.calculate(l: left, r: left) else { return .error }
                return .left(result)
            case .equal:
                return self
            default:
                return .error
            }
        case .leftOp(left: let left, op: let currentOp):
            switch op {
            case .plus, .minus, .mult, .div:
                return .leftOp(left: left, op: op)
            case .pow, .sqrt:
                guard let result = op.calculate(l: left, r: left) else { return .error }
                return .leftOp(left: result, op: currentOp)
            case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            default:
                return .error
            }
        case .leftOpRight(left: let left, op: let currentOp, right: let right):
            switch op {
            case .plus, .minus, .mult, .div:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .pow, .sqrt:
                guard let result = op.calculate(l: right, r: right) else { return .error }
                return .leftOpRight(left: left, op: currentOp, right: result)
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            default:
                return .error
            }
        case .error:
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

    func applyDot() -> String {
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

    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}
