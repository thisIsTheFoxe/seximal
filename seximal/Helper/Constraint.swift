//
//  Contraint.swift
//  timeExtension
//
//  Created by Henrik Storch on 24.06.21.
//

import Foundation
import CoreGraphics

#if os(tvOS)
struct Constraint {
    public static let marginLeading: CGFloat = 16
    public static let marginTrailing: CGFloat = 16
    public static let marginTop: CGFloat = 16
    public static let tickHeight: CGFloat = 8
    public static let longTickHeight: CGFloat = 14
    public static let tickWidth: CGFloat = 2
    public static let numberPadding: CGFloat = 40
    public static let actionButtonPadding: CGFloat = 16
    public static let needleViewWidth: CGFloat = 8
    public static let buttonCornerRadius: CGFloat = 10
    public static let needleViewBottomLineHeight: CGFloat = 30
    public static let calcPadding: CGFloat = 25
}
#elseif !os(watchOS)
struct Constraint {
    public static let marginLeading: CGFloat = 16
    public static let marginTrailing: CGFloat = 16
    public static let marginTop: CGFloat = 16
    public static let tickHeight: CGFloat = 8
    public static let longTickHeight: CGFloat = 14
    public static let tickWidth: CGFloat = 2
    public static let numberPadding: CGFloat = 40
    public static let actionButtonPadding: CGFloat = 16
    public static let needleViewWidth: CGFloat = 8
    public static let buttonCornerRadius: CGFloat = 10
    public static let needleViewBottomLineHeight: CGFloat = 30
    public static let calcPadding: CGFloat = 10
}
#else
struct Constraint {
    public static let marginLeading: CGFloat = 8
    public static let marginTrailing: CGFloat = 8
    public static let marginTop: CGFloat = 30
    public static let tickHeight: CGFloat = 4
    public static let longTickHeight: CGFloat = 7
    public static let tickWidth: CGFloat = 2
    public static let numberPadding: CGFloat = 20
    public static let actionButtonPadding: CGFloat = 8
    public static let needleViewWidth: CGFloat = 4
    public static let buttonCornerRadius: CGFloat = 5
    public static let needleViewBottomLineHeight: CGFloat = 15
    public static let calcPadding: CGFloat = 6
}
#endif
