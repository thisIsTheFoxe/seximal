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
        Double(converterText, radix: baseA.rawValue)
    }
    
    var convertedText: String {
        guard let number = number else {
            return baseB.abbreviatedName
        }
        return String(number, radix: baseB.rawValue)
    }
    
    var body: some View {
        VStack {
            Picker("Converter base: \(baseA.baseName)", selection: $baseA) {
                ForEach(Base.allCases) { base in
                    Text(base.baseName)
                }
            }
            TextField(baseA.abbreviatedName, text: $converterText) { (didChange) in
                print(didChange)
            }
            Button("Switch Bases") {
                if convertedText != baseB.abbreviatedName {
                    converterText = convertedText
                }
                swap(&baseA, &baseB)
            }
            .font(.headline)
            .padding(20)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10.0)
            .padding(.bottom, 20)
            Picker("Converted base: \(baseB.baseName)", selection: $baseB) {
                ForEach(Base.allCases) { base in
                    Text(base.baseName)
                }
            }
            Text(convertedText)
            Spacer()
            Text("Pronounciation in Seximal:")
                .font(.headline)
            if let num = number, let iNum = Int(num) {
                Text(iNum.spellInSex())
                    .padding()
            } else {
                Text("...")
                    .padding()
            }
            Text("For more information check the About section")
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
