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
    case plus, minus, mult, div
    
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
        default:
            return nil
        }
        
        return result ?? { String($0, radix: 6) } | nil
    }
}


// MARK: - Modifier
enum CalculatorModifier: CalculatorAction {
    case number(i: Int), pow, sqrt, comma, del, negate, rand
    
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
        }
        return nil
    }
}
