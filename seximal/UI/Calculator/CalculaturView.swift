//
//  CalculatorView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

#if os(tvOS)
extension UIColor {
    static let secondarySystemBackground = UIColor.gray
}
#endif

struct CalculatorView: View {

    @ObservedObject var model: Calculator = Calculator()

    let columns: [GridItem] = [
        GridItem(spacing: Constraint.calcPadding, alignment: .trailing),
        GridItem(spacing: Constraint.calcPadding, alignment: .center),
        GridItem(spacing: Constraint.calcPadding, alignment: .leading)]

    var body: some View {
        NavigationView {
            content
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var content: some View {
        VStack {
            GeometryReader { reader in
                Text(verbatim: model.logic.output)
                    .font(.system(size: 28))
                    .bold()
                    .padding()
                    .frame(width: reader.size.width, height: reader.size.height)
                    .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            }
            .frame(maxHeight: 100)
            .padding(.bottom)
#if !os(tvOS)
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = model.logic.output
                })
            }))
#endif
            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach(Calculator.Action.allCases) { op in
                    CalculatorButton(type: op, model: model)
                }
            })
#if !os(tvOS)

                .toolbar(content: {
                    Menu("Memory") {
                        ForEach(Calculator.MemoryAction.allCases) { action in
                            Button(action.displayName, action: { model.applyMemory(action: action) })
                        }
                    }
                })
#endif
        }
        .padding()
        .navigationTitle("Calculator")
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
