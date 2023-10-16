//
//  ConverterView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct NumberConverterView: View {
    @State var baseA: Base = .sex
    @State var baseB: Base = .dec
    @State var converterText: String = ""

    var number: Double? {
        let text: String
        if baseA == .doz {
            text = converterText
                .replacingOccurrences(of: "X", with: "A", options: .caseInsensitive)
                .replacingOccurrences(of: "E", with: "B", options: .caseInsensitive)
        } else { text = converterText }
        return Double(text, radix: baseA.rawValue)
    }

    var convertedText: String {
        guard let number = number else {
            return baseB.abbreviatedName
        }
        let result = String(number, radix: baseB.rawValue, grouping: baseB.grouping).uppercased()
        guard baseB == .doz else { return result }
        return result
            .replacingOccurrences(of: "A", with: "X")
            .replacingOccurrences(of: "B", with: "E")
    }

    var body: some View {
        VStack {
            Picker("Converter base: \(baseA.baseName)", selection: $baseA) {
                ForEach(Base.allCases) { base in
                    Text(base.baseName)
                }
            }
            TextField(baseA.abbreviatedName, text: $converterText) { (_) in
//                print(didChange)
            }
            .padding(6)
            .background(Color.gray.opacity(0.125))
            .padding()
            Button("Switch Bases") {
                if convertedText != baseB.abbreviatedName {
                    converterText = convertedText
                }
                swap(&baseA, &baseB)
            }
            .keyboardShortcut(.tab, modifiers: .option)
            .font(.headline)
            .padding(20)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10.0)
            .padding(.vertical, 20)
            Picker("Converted base: \(baseB.baseName)", selection: $baseB) {
                ForEach(Base.allCases) { base in
                    Text(base.baseName)
                }
            }
            Text(convertedText)
            Spacer()
            Text("Pronunciation in Seximal:")
                .font(.headline)
            if let num = number,
               num > Double(Int.min), num < Double(Int.max) {
                Text(Int(num).spellInSex())
                    .padding()
            } else {
                Text("...")
                    .padding()
            }
            Text("For more information check the About section.")
                .lineLimit(nil)
                .font(.footnote)
            Spacer()
        }
        .pickerStyle(MenuPickerStyle())
        .padding(.vertical, 20)
        .padding()
        .navigationTitle("Number Converter")
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NumberConverterView()
        }
    }
}
