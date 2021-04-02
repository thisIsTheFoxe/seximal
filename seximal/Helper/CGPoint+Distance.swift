//
//  CGPoint+Distance.swift
//  seximal
//
//  Created by Henrik Storch on 02.04.21.
//

import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
