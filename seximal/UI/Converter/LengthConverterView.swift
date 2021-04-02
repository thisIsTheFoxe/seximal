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
    
    var convertedMeasurement: Measurement<UnitLength>? {
        guard let value = Double(converterText, radix: radix(for: unitA)) else {
            return nil
        }
        
        let measureA = Measurement(value: value, unit: unitA)
        var result = measureA.converted(to: unitB)
        
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
            Text("A stick is exactly 0\(Locale.current.decimalSeparator ?? ".")9572 meter or 1\(Locale.current.decimalSeparator ?? ".")05 yards")
                .font(.headline)
            
            Picker("Converter unit: \(unitFormatter.customString(from: unitA))", selection: $unitA) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(unitFormatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            TextField(unitA.symbol, text: $converterText) { (didChange) in
//                print(didChange)
            }
            .padding(6)
            .background(Color.gray.opacity(0.125))
            .padding()
            Button("Switch Units") {
                if let newValue = convertedMeasurement?.value {
                    converterText = String(newValue, radix: radix(for: unitB))
                }
                swap(&unitA, &unitB)
            }
            .font(.headline)
            .padding(20)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10.0)
            .padding(.vertical, 20)
            Picker("Converted unit: \(unitFormatter.customString(from: unitB))", selection: $unitB) {
                ForEach(allUnits, id: \.self) { unit in
                    Text(unitFormatter.customString(from: unit))
                }
            }
            .pickerStyle(MenuPickerStyle())
            if let measurement = convertedMeasurement {
                Text(String(measurement.value, radix: radix(for: unitB), grouping: unitB.grouping) + " " + unitB.symbol)
            } else {
                Text(unitB.symbol)
            }
            Spacer()
            Text("For more information check the About section.")
                .font(.footnote)
            Spacer()
        }
        .padding()
        .navigationTitle("Lengths in Seximal")
        
    }
    
    func radix(for unit: UnitLength) -> Int {
        return customUnits.contains(unit) ? 6: 10
    }
}

struct LengthConverterView_Previews: PreviewProvider {
    static var previews: some View {
        LengthConverterView()
    }
}
