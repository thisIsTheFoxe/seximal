//
//  CalculatorView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var model: Calculator
    
    let columns: [GridItem] = [GridItem(spacing: 10, alignment: .trailing),GridItem(spacing: 10, alignment: .center),GridItem(spacing: 10, alignment: .leading)]
    
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
            .contextMenu(ContextMenu(menuItems: {
                Button("Copy", action: {
                    UIPasteboard.general.string = model.logic.output
                })
            }))
            .frame(maxHeight: 100)
            .padding(.bottom)
            LazyVGrid(columns: columns, spacing: 10, content: {
                ForEach(Calculator.Action.allCases) { op in
                    CalculatorButton(type: op)
                    //                        .padding(.top, 5)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Memory") {
                        ForEach(Calculator.MemoryAction.allCases) { action in
                            Button(action.displayName, action: { model.applyMemory(action: action) })
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Menu("Trigonometry") {
                        Section {
                            Button("Use " + (model.usesRad ? "Radians" : "Degrees"), action: { model.usesRad.toggle() })
                        }
                        ForEach(CalculatorModifier.TrigFunc.allCases) { action in
                            Button(action.displayName, action: {
                                model.apply(.mod(.trig(f: action)))
                            })
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Other") {
                        Section {
                            ForEach(CalculatorOp.Other.allCases) { action in
                                Button(action.displayName, action: {
                                    model.apply(.op(.other(t: action)))
                                })
                            }
                        }
                        Section {
                            ForEach(CalculatorModifier.Other.allCases) { action in
                                Button(action.displayName, action: {
                                    model.apply(.mod(.other(t: action)))
                                })
                            }
                        }
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


struct CalculatorButton: View {
    var type: Calculator.Action
    @EnvironmentObject var model: Calculator
    
    @State var isTapped = false
    
    var body: some View {
        Group {
            if let sysName = type.sfSymbolName {
                Image(systemName: sysName)
                    //                    .imageScale(.large)
                    .font(Font.title3.weight(.bold))
            } else {
                Text(type.displayName)
                    .font(.title3)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
        //        .frame(width: 100, height: 60)
        .background(type.backgroundColor)
        .foregroundColor(type.foregroundColor)
        .opacity(isTapped ? 0.5 : 1)
        .gesture(DragGesture(minimumDistance: 0).onChanged({ (tap) in
            self.isTapped = tap.location.distance(to: tap.startLocation) < 60
        }).onEnded({ (tap) in
            if isTapped {
                model.apply(type)
                isTapped = false
            }
        }))
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
