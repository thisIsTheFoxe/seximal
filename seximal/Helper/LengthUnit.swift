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

extension Calendar {
    var daysInYear: Int {
        range(of: .day, in: .year, for: Date())?.count ?? 356
    }
}
