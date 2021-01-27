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
    
    var grouping: Int {
        switch self {
        case .sticks, .untistick, .fetastick, .niftistick, .grandstick: return 4
        default: return 3
        }
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
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
}

extension String {
    func split(by length: Int) -> [String] {
        var endIx = self.endIndex
        var results = [Substring]()

        while endIx > self.startIndex {
            let startIx = self.index(endIx, offsetBy: -length, limitedBy: self.startIndex) ?? self.startIndex
            results.append(self[startIx..<endIx])
            endIx = startIx
        }
        
        return results.reversed().map { String($0) }
    }
}

extension String {
    public init<T>(_ value: T, radix: Int = 10, grouping: Int? = nil, uppercase: Bool = false) where T : BinaryFloatingPoint {
        let dValue = Double(value)
        //FIXME: int overflow
        var int = String(Int(dValue), radix: radix, uppercase: uppercase)
        if let grouping = grouping, int.count >= grouping {
            int = int.split(by: grouping).joined(separator: Locale.current.groupingSeparator ?? "")
        }
        
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
        
        if !fractalPart.isEmpty {
            fractalPart = (Locale.current.decimalSeparator ?? "") + fractalPart
        }
        
        self.init(int + fractalPart)
    }
}

extension BinaryFloatingPoint {
    public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
        let comp = text.components(separatedBy: Locale.current.decimalSeparator ?? "")
        guard comp.count <= 2, comp.count > 0 else {
            return nil
        }
        
        var intPart = comp[0]
        if let groupSeperator = Locale.current.groupingSeparator {
            intPart = intPart.replacingOccurrences(of: groupSeperator, with: "")
        }
        
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
