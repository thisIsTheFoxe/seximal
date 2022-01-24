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
        var fontSize = size.height > size.width ?
        size.width * 0.4 : size.height * 0.4
        fontSize = max(fontSize, 7)

        if let weight = weight {
            return .system(size: fontSize, weight: weight)
        } else if min(size.height, size.width) <= 20 {
            return .system(size: fontSize, weight: .bold)
        } else {
            return .system(size: fontSize, weight: .regular)
        }
    }
}
