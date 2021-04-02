//
//  CalculatorButtons.swift
//  seximal
//
//  Created by Henrik Storch on 02.04.21.
//

import SwiftUI

struct CalcButtonStyle: ButtonStyle {
    var type: Calculator.Action
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
            .background(type.backgroundColor)
            .foregroundColor(type.foregroundColor)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CalculatorButton: View {
    var type: Calculator.Action
    @EnvironmentObject var model: Calculator
    
    @State var isTapped = false
    
    var body: some View {
        if let key = type.keyboardShortcut {
            content
                .keyboardShortcut(key, modifiers: [])
        } else {
            content
        }
    }
    
    var content: some View {
        Button(action: {
            model.apply(type)
        }, label: {
            if let sysName = type.sfSymbolName {
                Image(systemName: sysName)
                    //                    .imageScale(.large)
                    .font(Font.title3.weight(.bold))
            } else {
                Text(type.displayName)
                    .font(.title3)
                    .bold()
            }
        })
        .buttonStyle(CalcButtonStyle(type: type))
    }
}
