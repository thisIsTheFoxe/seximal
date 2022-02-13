//
//  CalculatorButtons.swift
//  seximal
//
//  Created by Henrik Storch on 02.04.21.
//

import SwiftUI

struct CalcButtonStyle: ButtonStyle {
    var type: Calculator.Action

    var minHeight: CGFloat {
        #if !os(watchOS)
        return 60
        #else
        return 22
        #endif
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: minHeight, maxHeight: .infinity)
            .background(type.backgroundColor)
            .foregroundColor(type.foregroundColor)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct CalculatorButton: View {
    var type: Calculator.Action
    var font: Font?
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
            GeometryReader { reader in
                if let sysName = type.sfSymbolName {
                    Image(systemName: sysName)
                        //                    .imageScale(.large)
                        .font(font ?? .forViewSize(reader.size, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Text(type.displayName)
                        .font(font ?? .forViewSize(reader.size, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        })
        .buttonStyle(CalcButtonStyle(type: type))
    }
}
