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
        default:
            return apply(op: item)
//        case .command(let command):
//            return apply(command: command)
        }
    }

    var output: String {
        let result: String
        switch self {
        case .left(let left): result = left
        case .leftOp(let left, _): result = left
        case .leftOpRight(_, _, let right): result = right
        case .error: return "Error"
        }
        
        guard let value = Double(result, radix: 6) else {
            return "Error"
        }
        
        let resString = String(value, radix: 6)
        
        if result.containsDot && !resString.containsDot {
            return resString.applyDot()
        } else {
            return resString
        }
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
    
//
//    private func apply(command: CalculatorButtonItem.Command) -> CalculatorLogic {
//        switch command {
//        case .clear:
//            return .left("0")
//        case .flip:
//            switch self {
//            case .left(let left):
//                return .left(left.flipped())
//            case .leftOp(let left, let op):
//                return .leftOpRight(left: left, op: op, right: "-0")
//            case .leftOpRight(left: let left, let op, let right):
//                return .leftOpRight(left: left, op: op, right: right.flipped())
//            case .error:
//                return .left("-0")
//            }
//        case .percent:
//            switch self {
//            case .left(let left):
//                return .left(left.percentaged())
//            case .leftOp:
//                return self
//            case .leftOpRight(left: let left, let op, let right):
//                return .leftOpRight(left: left, op: op, right: right.percentaged())
//            case .error:
//                return .left("-0")
//            }
//        }
//    }
}

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

extension String {
    var containsDot: Bool {
        return contains(Locale.current.decimalSeparator ?? ".")
    }

    var startWithNegative: Bool {
        return starts(with: "-")
    }

    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }

    func applyDot() -> String {
        return containsDot ? self : self + (Locale.current.decimalSeparator ?? ".")
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
