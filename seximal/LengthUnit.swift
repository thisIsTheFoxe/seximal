//
//  LengthUnit.swift
//  seximal
//
//  Created by Henrik Storch on 26.01.21.
//

import Foundation

extension UnitLength {
    static var sticks: UnitLength {
        let converter = UnitConverterLinear(coefficient: 0.9572)
        return UnitLength(symbol: NSLocalizedString("st", comment: "sticks"), converter: converter)
    }
    
    static var niftistick: UnitLength {
        let converter = UnitConverterLinear(coefficient: 0.9572 / 36)
        return UnitLength(symbol: NSLocalizedString("nftst", comment: "niftistick"), converter: converter)
    }
    
    static var untistick: UnitLength {
        let converter = UnitConverterLinear(coefficient: 0.9572 / (36 * 36))
        return UnitLength(symbol: NSLocalizedString("untst", comment: "untistick"), converter: converter)
    }
    
    static var fetastick: UnitLength {
        let converter = UnitConverterLinear(coefficient: 0.9572 * 36)
        return UnitLength(symbol: NSLocalizedString("ftast", comment: "fetastick"), converter: converter)
    }
    
    static var grandstick: UnitLength {
        let converter = UnitConverterLinear(coefficient: 0.9572 * 36 * 36)
        return UnitLength(symbol: NSLocalizedString("grdst", comment: "grandstick"), converter: converter)
    }
}

extension Measurement where UnitType == UnitLength {
    
}

extension MeasurementFormatter {
    func customString(from unit: Unit) -> String {
        guard self.unitStyle == .long else {
            return self.string(from: unit)
        }
        
        switch unit {
        case UnitLength.sticks: return "sticks"
        case UnitLength.niftistick: return "niftistick"
        case UnitLength.untistick: return "untistick"
        case UnitLength.fetastick: return "fetastick"
        case UnitLength.grandstick: return "grandstick"
            
        default: return self.string(from: unit)
        }
    }
}

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
}

extension String {
    public init<T>(_ value: T, radix: Int = 10, uppercase: Bool = false) where T : BinaryFloatingPoint {
        let dValue = Double(value)
        let int = String(Int(dValue), radix: radix)
        
        var remainder = dValue - Double(Int(dValue))
        var fractalPart = ""
        for ix in 1...16 {
            guard remainder != 0 else { break }
            let pwr = Double(truncating: NSDecimalNumber(decimal: pow(Decimal(radix), ix)))
            let newValue = Int(remainder * pwr) //truncation needed
            let divident =  Double(truncating: NSDecimalNumber(decimal: pow(Decimal(radix), ix)))
            let ratio = Double(newValue) / divident
            remainder -= ratio
            fractalPart += String(newValue, radix: radix, uppercase: uppercase)
        }
        
        fractalPart = fractalPart.replacingOccurrences(of: "0*$", with: "", options: .regularExpression)
        
        self.init(int + (Locale.current.decimalSeparator ?? "") + fractalPart)
    }
}

extension BinaryFloatingPoint {
    public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
        let comp = text.components(separatedBy: Locale.current.decimalSeparator ?? "")
        guard comp.count <= 2, comp.count > 0 else {
            return nil
        }
        
        let intPart = comp[0]
        guard let int = Int(intPart, radix: radix) else {
            return nil
        }
        
        var fractal = 0.0
        if comp.count == 2 {
            let fractalPart = comp[1]
            for cIx in 0..<fractalPart.count {
                let char = String(fractalPart[cIx])
                guard let charAsInt = Int(char, radix: radix) else { return nil }
                let bPart = Double(truncating: NSDecimalNumber(decimal: pow(Decimal(radix), cIx + 1)))
                fractal += Double(charAsInt) * (1.0 / bPart)
            }
        }
        
        self.init(Double(int) + fractal)
    }
}
