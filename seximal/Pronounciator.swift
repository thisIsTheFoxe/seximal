//
//  Pronounciator.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import Foundation

extension Int {
    var asWord: String {
      let numberValue = NSNumber(value: self)
      let formatter = NumberFormatter()
      formatter.numberStyle = .spellOut
      return formatter.string(from: numberValue) ?? ""
    }
    
    func spellInSex() -> String {
        guard !(0...12).contains(self) else {
            if self == 0 { return "" }
            return asWord
        }
        
        let dozens = self / 6
        let nifs = self / 36
        let nifRest = self % 36
        let exian = self / 1296
        let exianRest = self % 1296
        let rest = self % 6
        switch dozens {
        case 2: return "dozen " + rest.spellInSex()
        case 3: return "thirsy " + rest.spellInSex()
        case 4: return "foursy " + rest.spellInSex()
        case 5: return "fifsy " + rest.spellInSex()
        case 6...215:
            var result = ""
            if nifs > 1 {
                result += nifs.spellInSex() + " "
            }
            result += "nif"
            if nifRest > 0 {
                result += " " + nifRest.spellInSex()
            }
            return result
        case 216...279_935:
            var result = ""
            if exian > 1 {
                result += exian.spellInSex() + " "
            }
            result += "unexian"
            if exianRest > 0 {
                result += " " + exianRest.spellInSex()
            }
            return result
        default:
            return ""
        }
    }
}
