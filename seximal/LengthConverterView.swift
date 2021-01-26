//
//  LengthConverterView.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import SwiftUI

struct LengthConverterView: View {
    
    let allUnits: [UnitLength] = [
        .grandstick, .fetastick, .sticks, .niftistick, .untistick,
        .kilometers, .meters, .centimeters, .millimeters,
        .inches, .feet, .yards, .miles,
        .nauticalMiles
    ]
    
    let customUnits = [UnitLength.grandstick, .fetastick, .sticks, .niftistick, .untistick]
    
    let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .providedUnit
        return formatter
    }()
    
    @State var unitA: UnitLength = .sticks
    @State var unitB: UnitLength = .meters
    
    @State var converterText = ""

    var convertedText: String {
        let ftter = MeasurementFormatter()
        ftter.unitOptions = .providedUnit
        
        let radix = customUnits.contains(unitA) ? 6: 10
        guard let value = Int(converterText, radix: radix) else {
            return unitB.symbol
        }
        
        let messuareA = Measurement(value: Double(value), unit: unitA)
        var result = messuareA.converted(to: unitB)
        
        if customUnits.contains(unitB) {
            let newStr = String(Int(result.value), radix: 6)
            guard let newVal = Double(newStr) else {
                return unitB.symbol
            }
            result.value = newVal
        }
        return ftter.string(from: result)
    }
        
    var body: some View {
        VStack {
            Text("A stick is exactly 0.9572 meter or 1.05 yards")
                .font(.headline)
            
            Picker("Converter unit: \(formatter.customString(from: unitA))", selection: $unitA) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(formatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            TextField(unitA.symbol, text: $converterText) { (didChange) in
                print(didChange)
            }
            Button("Switch Units") {
                if convertedText != unitB.symbol {
                    converterText = convertedText
                }
                swap(&unitA, &unitB)
            }
            .font(.headline)
            .padding(20)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10.0)
            .padding(.bottom, 20)
            Picker("Converted unit: \(formatter.customString(from: unitB))", selection: $unitB) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(formatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            Text(convertedText)
            Spacer()
            Text("Pronounciation in Seximal:")
                .font(.headline)
//            Text(number?.spellInSex() ?? "...")
//                .padding()
            Text("For more information check the About section")
                .lineLimit(nil)
                .font(.footnote)
            Spacer()
        }
        .padding()
        .navigationTitle("Lengths in Seximal")
        
    }
}

struct LengthConverterView_Previews: PreviewProvider {
    static var previews: some View {
        LengthConverterView()
    }
}
