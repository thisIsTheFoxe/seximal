//
//  WatchCalculatorView.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import SwiftUI

struct WatchCalculatorView: View {
    @ObservedObject var model: Calculator = Calculator()

    let columns: [GridItem] = [
        GridItem(spacing: Constraint.calcPadding, alignment: .trailing),
        GridItem(spacing: Constraint.calcPadding, alignment: .center),
        GridItem(spacing: Constraint.calcPadding, alignment: .center)]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(model.logic.output)
                    .font(.system(size: 20))
                if model.logic.output != "0" {
                    Image(systemName: "delete.left.fill")
                        .imageScale(.large)
                        .onTapGesture {
                            model.apply(.mod(.del))
                        }
                    .background(Color.black)
                }
            }
            Divider()
            LazyVGrid(columns: columns, spacing: Constraint.calcPadding, content: {
                ForEach(Calculator.Action.allCases) { op in
                    CalculatorButton(type: op, font: .body.bold())
                        .cornerRadius(6)
//                                            .padding(.top, 5)
                }
            })
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCalculatorView()
    }
}
