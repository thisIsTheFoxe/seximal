//
//  Base.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import Foundation

enum Base: Int, CaseIterable, Identifiable {
    var id: Base { self }

    case bin = 2, sex = 6, oct = 8, dec = 10, doz = 12, hex = 16, nif = 36

    var grouping: Int? {
        switch self {
        case .dec: return 3
        case .sex: return 4
        default: return nil
        }
    }

    var baseName: String {
        switch self {
        case .bin: return "Binary"
        case .sex: return "Seximal"
        case .oct: return "Octal"
        case .dec: return "Decimal"
        case .doz: return "Dozenal"
        case .hex: return "Hexadecimal"
        case .nif: return "Niftimal"
        }
    }

    var abbreviatedName: String {
        switch self {
        case .bin: return "bin"
        case .sex: return "sex"
        case .oct: return "oct"
        case .dec: return "dec"
        case .nif: return "nif"
        case .doz: return "doz"
        case .hex: return "hex"
        case .nif: return "nif"
        }
    }
}
