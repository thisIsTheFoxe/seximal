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

public extension AnyTransition {
    static var verticalSlide: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: VerticalSlideViewModifier(isActive: true, insertion: true),
                identity: VerticalSlideViewModifier(isActive: false, insertion: true)
            ),
            removal: .modifier(
                active: VerticalSlideViewModifier(isActive: true, insertion: false),
                identity: VerticalSlideViewModifier(isActive: false, insertion: false)
            )
        )
    }
}

private struct VerticalSlideViewModifier: ViewModifier {
    let isActive: Bool
    let insertion: Bool
    let offset: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 0 : 1)
            .opacity(isActive ? 0 : 1)
            .offset(x: 0, y: isActive ?
                    // could use GeometryReader.height but messes with other views
                    (insertion ? -offset : offset)
                    : (insertion ? offset : -offset))
    }
}
