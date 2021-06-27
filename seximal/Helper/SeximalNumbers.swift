//
//  SeximalNumbers.swift
//  seximal
//
//  Created by Henrik Storch on 02.04.21.
//

import Foundation

extension Double {
    func asSexInt(padding: Int = 0) -> String {
        Int(self).asSex(padding: padding)
    }
}

extension Int {
    ///interprets the number as a seximal integer written in decimal
    func asSex(padding: Int = 0) -> String {
        var result = String(self, radix: 6)
        let missing = Swift.max(0, padding - result.count)
        for _ in 0..<missing {
            result = "0" + result
        }
        return result
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

extension UInt64 {
    init(safely double: Double) {
        //: int overflow / can be NaN
        if double.isNaN || double.isInfinite {
            self = 0
        } else if double >= pow(6.0, 20) {
            self = UInt64(pow(6.0, 20))
        } else if double < Double(UInt64.min) {
            self = UInt64.min
        } else {
            self = UInt64(double)
        }
    }
}

extension String {
    public init<T>(_ value: T, radix: Int = 10, grouping: Int? = nil, uppercase: Bool = false) where T : BinaryFloatingPoint {
        let sign = value < 0 ? "-" : ""
        let dValue = Double(abs(value))
        
        //fixme: don't use int.... eh, it's fine..
        var iValue = UInt64(safely: dValue)
        let roundPlaces: Double = 16
        
        var remainder = dValue - floor(dValue)
        remainder *= pow(6, roundPlaces)
        remainder.round()
        remainder /= pow(6, roundPlaces)
        
        if remainder >= 1 {
            iValue += UInt64(floor(remainder))
            remainder -= floor(remainder)
        }
        
        var fractalPart = ""
        //FIXME: use UInt64 (or probaly 32 is enough) also for fractal and scale it down..?
        for ix in 1...16 {
            guard remainder != 0 else { break }
            let pwr = Double(truncating: NSDecimalNumber(decimal: pow(Decimal(radix), ix)))
            let newValue = UInt64(safely: remainder * pwr) //truncation needed, to use default String call
            let divident =  Double(truncating: NSDecimalNumber(decimal: pow(Decimal(radix), ix)))
            let ratio = Double(newValue) / divident
            remainder -= ratio
            fractalPart += String(newValue, radix: radix, uppercase: uppercase)
        }
        
        fractalPart = fractalPart.replacingOccurrences(of: "0*$", with: "", options: .regularExpression)
        
        if !fractalPart.isEmpty {
            fractalPart = (Locale.current.decimalSeparator ?? "") + fractalPart
        }
        
        var int = String(iValue, radix: radix, uppercase: uppercase)
        if let grouping = grouping, int.count >= grouping {
            int = int.split(by: grouping).joined(separator: Locale.current.groupingSeparator ?? "")
        }
        
        self.init(sign + int + fractalPart)
    }
}

extension BinaryFloatingPoint {
    public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol {
        let comp = text.components(separatedBy: Locale.current.decimalSeparator ?? "")
        guard comp.count <= 2, comp.count > 0 else {
            return nil
        }
        
        var intPart = comp[0]
        var isNegative = false
        
        if intPart.first == "-" {
            _ = intPart.removeFirst()
            isNegative = true
        }
        
        if let groupSeparator = Locale.current.groupingSeparator {
            intPart = intPart.replacingOccurrences(of: groupSeparator, with: "")
        }
        
        guard let int = UInt64(intPart, radix: radix) else {
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
        
        var result = Double(int) + fractal
        if isNegative {
            result.negate()
        }
        
        self.init(result)
    }
}
