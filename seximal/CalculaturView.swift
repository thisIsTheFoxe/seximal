//
//  CalculaturView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

enum CalculatorOperation: CaseIterable, Hashable, Identifiable {
    var id: CalculatorOperation { self }
        
    static var allCases: [CalculatorOperation] = [
        .number(i: 0), .number(i: 1), .comma,
        .number(i: 2), .number(i: 3), .clear,
        .number(i: 4), .number(i: 5), .del,
        .plus, .minus, equal,
        .mult, .div, .negate,
        .pow, .sqrt, .rand
    ]
    
    case number(i: Int), plus, minus, mult, div, equal, pow, sqrt, comma, clear, del, negate, rand
    
    var sfSymbolName: String? {
        switch self {
        case .plus: return "plus"
        case .minus: return "minus"
        case .mult: return "multiply"
        case .div: return "divide"
        case .equal: return "equal"
        case .sqrt: return "x.squareroot"
        case .del: return "delete.left"
        case .negate: return "plus.slash.minus"
        default: return nil
        }
    }
    
    var displayName: String {
        switch self {
        case .number(let i): return String(i)
        case .plus: return "+"
        case .minus: return "-"
        case .mult: return "*"
        case .div: return "/"
        case .equal: return "="
        case .pow: return "x²"
        case .sqrt: return "√"
        case .comma: return Locale.current.decimalSeparator ?? "."
        case .clear: return "AC"
        case .del: return "Del"
        case .negate: return "+/-"
        case .rand: return "Rand"
        default: return "?"
        }
    }
    
    var backgoundColor: Color {
        switch self {
        case .number, .comma:
            return Color.gray.opacity(0.25)
        case .plus, .minus, .mult, .div, .equal:
            return .orange
        default:
            return Color.gray.opacity(0.125)
        }
    }
    
    private var hashId: Int {
        switch self {
        case .number(i: _): return 0
        case .plus: return 1
        case .minus: return 2
        case .mult: return 3
        case .div: return 4
        case .equal: return 5
        case .pow: return 6
        case .sqrt: return 7
        case .comma: return 8
        case .del: return 9
        case .clear: return 10
        case .negate: return 11
        case .rand: return 12
        default: return 9999
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .number(let value):
            hasher.combine(value) // combine with associated value, if it's not `Hashable` map it to some `Hashable` type and then combine result
            break
        default: break
        }
        
        //not rly needed for some reason, works without
        //but better safe than sorry...
        hasher.combine(self.hashId)
    }
}

extension CalculatorOperation {
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
        case .pow: result = left * left
        case .sqrt: result = Darwin.sqrt(left)
        case .equal: fatalError()
        default:
            return nil
        }
        
        return result ?? { String($0, radix: 6) } | nil
    }
}


struct CalculaturView: View {
    
    @EnvironmentObject var model: Calculator
    
    let colums: [GridItem] = Array(repeating: GridItem(spacing: 5), count: 3)
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { g in
                    Text(verbatim: model.logic.output)
                        .font(.title2)
                        .frame(width: g.size.width, height: g.size.height)
                        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                }
                Spacer(minLength: 18)
                LazyVGrid(columns: colums, content: {
                    ForEach(CalculatorOperation.allCases) { op in
                        CalculatorButton(type: op)
                    }
                })
            }
            .padding()
            .navigationTitle("Calculator")
        }
    }
}

struct CalculaturView_Previews: PreviewProvider {
    static var previews: some View {
        CalculaturView()
    }
}

struct CalculatorButton: View {
    var type: CalculatorOperation
    @EnvironmentObject var model: Calculator

    var body: some View {
        Group {
            if let sysName = type.sfSymbolName {
                Image(systemName: sysName)
            } else {
                Text(type.displayName)
            }
        }
        .frame(width: 100, height: 65, alignment: .center)
        .background(type.backgoundColor)
        .padding(5)
        .onTapGesture {
            model.apply(type)
        }
    }
}
