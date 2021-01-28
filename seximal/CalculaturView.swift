//
//  CalculaturView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct CalculaturView: View {
    
    @EnvironmentObject var model: Calculator
    
    let colums: [GridItem] = [GridItem(spacing: 5, alignment: .trailing),GridItem(spacing: 5, alignment: .center),GridItem(spacing: 5, alignment: .leading)]
    
    var body: some View {
        #if targetEnvironment(macCatalyst)
        content
        #else
        NavigationView {
            content
        }
        #endif
    }
    
    var content: some View {
        VStack {
            GeometryReader { g in
                Text(verbatim: model.logic.output)
                    .font(.title2)
                    .frame(width: g.size.width, height: g.size.height)
                    .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            }
            Spacer(minLength: 18)
            LazyVGrid(columns: colums, content: {
                ForEach(Calculator.Action.allCases) { op in
                    CalculatorButton(type: op)
                        .padding(.top, 5)
                }
            })
        }
        .padding()
        .navigationTitle("Calculator")
    }
}

struct CalculaturView_Previews: PreviewProvider {
    static var previews: some View {
        CalculaturView()
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
        .frame(width: 100, height: 60, alignment: .center)
        .background(type.backgoundColor)
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
