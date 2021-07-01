//
//  UI.swift
//  seximal
//
//  Created by Henrik Storch on 01.07.21.
//

import Foundation
import SwiftUI

extension Font {
    static func forViewSize(_ size: CGSize, weight: Font.Weight? = nil) -> Font {
        var s = size.height > size.width ?
        size.width * 0.4 : size.height * 0.4
        s = max(s, 7)
        
        if let weight = weight {
            return .system(size: s, weight: weight)
        } else if min(size.height, size.width) <= 20 {
            return .system(size: s, weight: .bold)
        } else {
            return .system(size: s, weight: .regular)
        }
    }
}
