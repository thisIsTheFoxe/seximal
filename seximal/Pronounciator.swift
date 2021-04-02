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
        let unexian = self / 1296
        let unexianRest = self % 1296
        let biexian = self / 1_679_616
        let biexianRest = self % 1_679_616
        let triexian = self / 2_176_782_336
        let triexianRest = self % 2_176_782_336
        let quadexian = self / 2_821_109_907_456
        let quadexianRest = self % 2_821_109_907_456
        let rest = self % 6
        
        ///NOTE: Not switchng self, but divided by six
        switch dozens {
        case 2: return "dozen " + rest.spellInSex()
        case 3: return "thirsy " + rest.spellInSex()
        case 4: return "foursy " + rest.spellInSex()
        case 5: return "fifsy " + rest.spellInSex()
        case 6..<216:
            var result = ""
            if nifs > 1 {
                result += nifs.spellInSex() + " "
            }
            result += "nif"
            if nifRest > 0 {
                result += " " + nifRest.spellInSex()
            }
            return result
        //6**(8-1)
        case 216..<279_936:
            var result = ""
            if unexian > 1 {
                result += unexian.spellInSex() + " "
            }
            result += "unexian"
            if unexianRest > 0 {
                result += " " + unexianRest.spellInSex()
            }
            return result
            //6**(12-1)
        case 279_936..<362_797_056:
            var result = ""
            if biexian > 1 {
                result += biexian.spellInSex() + " "
            }
            result += "biexian"
            if biexianRest > 0 {
                result += " " + biexianRest.spellInSex()
            }
            return result
            //6**(16-1)
        case 362_797_056..<470_184_984_576:
            var result = ""
            if triexian > 1 {
                result += triexian.spellInSex() + " "
            }
            result += "triexian"
            if triexianRest > 0 {
                result += " " + triexianRest.spellInSex()
            }
            return result
        //6**(20-1)
        case 470_184_984_576..<609_359_740_010_496:
            var result = ""
            if quadexian > 1 {
                result += quadexian.spellInSex() + " "
            }
            result += "quadexian"
            if quadexianRest > 0 {
                result += " " + quadexianRest.spellInSex()
            }
            return result
        case 609_359_740_010_496:
            return "pentexian"
        default:
            return ""
        }
    }
}
