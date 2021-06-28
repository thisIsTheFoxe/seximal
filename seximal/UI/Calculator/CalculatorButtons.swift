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
        #if !os(watchOS)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
        #else
            .frame(maxWidth: .infinity, minHeight: 22, maxHeight: .infinity)
        #endif
            .background(type.backgroundColor)
            .foregroundColor(type.foregroundColor)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CalculatorButton: View {
    var type: Calculator.Action
    var font = Font.title3
    @EnvironmentObject var model: Calculator
    
    @State var isTapped = false
    
    var body: some View {
        #if !os(watchOS)
        if let key = type.keyboardShortcut {
            content
                .keyboardShortcut(key, modifiers: [])
        } else {
            content
        }
        #else
        content
        #endif
    }
    
    var content: some View {
        Button(action: {
            model.apply(type)
        }, label: {
            if let sysName = type.sfSymbolName {
                Image(systemName: sysName)
                    //                    .imageScale(.large)
                    .font(font.weight(.bold))
            } else {
                Text(type.displayName)
                    .font(font)
                    .bold()
            }
        })
        .buttonStyle(CalcButtonStyle(type: type))
    }
}
