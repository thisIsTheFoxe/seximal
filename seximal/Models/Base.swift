//
//  Base.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import Foundation

enum Base: Int, CaseIterable, Identifiable {
    var id: Base { self }
    
    case dec = 10, sex = 6, bin = 2, doz = 12, oct = 8, hex = 16
    
    var grouping: Int? {
        switch self {
        case .dec: return 3
        case .sex: return 4
        default: return nil
        }
    }
    
    var baseName : String {
        switch self {
        case .bin: return "Binary"
        case .sex: return "Seximal"
        case .oct: return "Octal"
        case .dec: return "Decimal"
        case .doz: return "Dozenal"
        case .hex: return "Hexadecimal"
        default:
            return "??"
        }
    }
    
    var abbreviatedName: String {
        switch self {
        case .bin: return "bin"
        case .sex: return "sex"
        case .oct: return "oct"
        case .dec: return "dec"
        case .doz: return "doz"
        case .hex: return "hex"
        default:
            return "??"
        }
    }
}
