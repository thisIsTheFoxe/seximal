//
//  CalculatorAction.swift
//  seximal
//
//  Created by Henrik Storch on 28.01.21.
//

import Foundation
import SwiftUI

protocol CalculatorAction: Hashable, Identifiable {
    var sfSymbolName: String? { get }
    var displayName: String { get }
}


// MARK: - Operations
enum CalculatorOp: CalculatorAction {
    enum Other: CalculatorAction, CaseIterable {
        var sfSymbolName: String? { nil }
        
        var displayName: String {
            switch self {
            case .powY: return "x^y"
            case .rootY: return "xth root of y"
            }
        }
        
        var id: Other { self }
        
        case powY, rootY
    }
    
    case plus, minus, mult, div, other(t: Other)
    
    var id: CalculatorOp { self }
    
    var sfSymbolName: String? {
        switch self {
        case .plus: return "plus"
        case .minus: return "minus"
        case .mult: return "multiply"
        case .div: return "divide"
        default: return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .mult: return "*"
        case .div: return "/"
        case .other(t: let t): return t.displayName
        default: return "?"
        }
    }
        
    func calculate(l: String, r: String) -> String? {

        guard let left = Double(l, radix: 6), let right = Double(r, radix: 6) else {
            return nil
        }
        
        let result: Double?
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .mult: result = left * right
        case .div: result = right == 0 ? nil : left / right
        case .other(t: let t):
            switch t {
            case .powY:
                result = pow(left, right)
            case .rootY:
                result = pow(left, 1/right)
            }
        default:
            return nil
        }
        
        return result ?? { String($0, radix: 6) } | nil
    }
}


// MARK: - Modifier
enum CalculatorModifier: CalculatorAction {
    enum TrigFunc: CalculatorAction, CaseIterable {
        case sin, asin,
             cos, acos,
             tan, atan
        
        var sfSymbolName: String? { nil }
        
        var displayName: String {
            switch self {
            case .sin: return "Sine"
            case .asin: return "Arc-Sine"
            case .cos: return "Cosine"
            case .acos: return "Arc-Cosine"
            case .tan: return "Tangent"
            case .atan: return "Arc-Tangent"
            }
        }
        
        var id: TrigFunc { self }
    }
    
    enum Other: CalculatorAction, CaseIterable {
        var sfSymbolName: String? { nil }
        
        var displayName: String {
            switch self {
            case .factorial: return "x!"
            case .eToX: return "e^x"
            case .ln: return "ln(x)"
            case .pi: return "Pi"
            }
        }
        
        var id: Other { self }
        
        case pi, eToX, ln, factorial
    }
    
    case number(i: Int), pow, sqrt, comma, del, negate, rand, trig(f: TrigFunc), other(t: Other)
    
    var id: CalculatorModifier { return self }
    
    var sfSymbolName: String? {
        switch self {
        case .sqrt: return "x.squareroot"
        case .del: return "delete.left"
        case .negate: return "plus.slash.minus"
        default: return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .number(let i): return String(i)
        case .pow: return "x²"
        case .sqrt: return "√"
        case .comma: return Locale.current.decimalSeparator ?? "."
        case .del: return "Del"
        case .negate: return "+/-"
        case .rand: return "Rand"
        case .trig(f: let f): return f.displayName
        case .other(t: let t): return t.displayName
        default: return "?"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .number, .comma:
            return Color.gray.opacity(0.25)
        default:
            return Color.gray.opacity(0.125)
        }
    }
    
    func modify(text: String) -> String? {
        switch self {
        case .number(i: let num):
            return text.apply(num: num)
        case .pow:
            guard let left = Double(text, radix: 6) else {
                return nil
            }
            let result = left * left
            return String(result, radix: 6)
        case .sqrt:
            guard let left = Double(text, radix: 6) else {
                return nil
            }
            let result = Darwin.sqrt(left)
            return String(result, radix: 6)
        case .comma:
            return text.applyDecSeparator()
        case .del:
            return text.deletingLast()
        case .negate:
            return text.negate()
        case .rand:
            return String(Double.random(in: 0...1), radix: 6)
            
            //TODO: add rad / deg
        case .trig(f: let f):
            guard let left = Double(text, radix: 6) else {
                return nil
            }
            let result: Double
            switch f {
            case .sin: result = sin(left)
            case .asin: result = asin(left)
            case .cos: result = asin(left)
            case .acos: result = acos(left)
            case .tan: result = tan(left)
            case .atan: result = atan(left)
            }
            return String(result, radix: 6)
        case .other(t: let t):
            switch t {
            case .eToX:
                guard let left = Double(text, radix: 6) else {
                    return nil
                }
                let result = exp(left)
                return String(result, radix: 6)
            case .factorial:
                //TODO: implement
                guard let left = Double(text, radix: 6) else {
                    return nil
                }
                print(left)
            case .ln:
                guard let left = Double(text, radix: 6) else {
                    return nil
                }
                let result = log(left)
                return String(result, radix: 6)
            case .pi:
                return String(Double.pi, radix: 6)
            }
        }
        return nil
    }
}
