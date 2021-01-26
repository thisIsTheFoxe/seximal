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
    
    let unitFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .providedUnit
        return formatter
    }()
    
    @State var unitA: UnitLength = .sticks
    @State var unitB: UnitLength = .meters
    
    @State var converterText = ""

    let measureFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter
    }()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    var convertedMesuremnt: Measurement<UnitLength>? {
        let radix = customUnits.contains(unitA) ? 6: 10
        guard let value = Double(converterText, radix: radix) else {
            return nil
        }
        
        let messuareA = Measurement(value: value, unit: unitA)
        var result = messuareA.converted(to: unitB)
        
        if customUnits.contains(unitB) {
            let newStr = String(result.value, radix: 6)
            guard let newVal = Double(newStr, radix: 6) else {
                return nil
            }
            result.value = newVal
        }
        return result
    }
        
    var body: some View {
        VStack {
            Text("A stick is exactly 0.9572 meter or 1.05 yards")
                .font(.headline)
            
            Picker("Converter unit: \(unitFormatter.customString(from: unitA))", selection: $unitA) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(unitFormatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            TextField(unitA.symbol, text: $converterText) { (didChange) in
                print(didChange)
            }
            Button("Switch Units") {
                if let newValue = convertedMesuremnt?.value {
                    let radix = customUnits.contains(unitB) ? 6: 10
                    converterText = String(newValue, radix: radix)
                }
                swap(&unitA, &unitB)
            }
            .font(.headline)
            .padding(20)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10.0)
            .padding(.bottom, 20)
            Picker("Converted unit: \(unitFormatter.customString(from: unitB))", selection: $unitB) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(unitFormatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            if let measurement = convertedMesuremnt {
                Text(measureFormatter.string(from: measurement))
            } else {
                Text(unitB.symbol)
            }
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
