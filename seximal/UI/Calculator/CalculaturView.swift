//
//  CalculatorView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct CalculatorView: View {

    @EnvironmentObject var model: Calculator

    let columns: [GridItem] = [GridItem(spacing: 10, alignment: .trailing), GridItem(spacing: 10, alignment: .center), GridItem(spacing: 10, alignment: .leading)]

    var body: some View {
        NavigationView {
            content
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var content: some View {
        VStack {
            GeometryReader { g in
                Text(verbatim: model.logic.output)
                    .font(.system(size: 28))
                    .bold()
                    .padding()
                    .frame(width: g.size.width, height: g.size.height)
                    .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            }
            .frame(maxHeight: 100)
            .padding(.bottom)
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = model.logic.output
                })
            }))

            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach(Calculator.Action.allCases) { op in
                    CalculatorButton(type: op)
                    //                        .padding(.top, 5)
                }
            })
                .toolbar(content: {
                    Menu("Memory") {
                        ForEach(Calculator.MemoryAction.allCases) { action in
                            Button(action.displayName, action: { model.applyMemory(action: action) })
                        }
                    }
                })
        }
        .padding()
        .navigationTitle("Calculator")
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(Calculator())
    }
}
