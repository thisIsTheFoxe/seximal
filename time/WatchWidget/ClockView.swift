//
//  ClockView.swift
//  seximal
//
//  Created by Henrik Storch on 26.06.21.
//

import SwiftUI

struct ClockView: View {
    var isSmall: Bool
    var showDate: Bool
    var useTwoHourHands: Bool
    var showDigitally: Bool
    var showSecondsHand: Bool
    
    var strokeScalar: CGFloat { isSmall ? 1 : 1.5 }
    
    var titleFont: Font
    var textFont: Font
    
    @ObservedObject var time: SexTime
    
    var lapseAngle: CGFloat {
        useTwoHourHands ?
        CGFloat(time.lapse / 6) / 6 :
        CGFloat(time.lapse) / 36
    }
    
    var sisthLapseAngel: CGFloat {
        useTwoHourHands ?
        CGFloat(time.lapse % 6) / 6 :
        0
    }
    
    var borderColor: Color {
        #if !os(watchOS)
            return Color(UIColor.label)
        #else
            return .white
        #endif
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
                let size = getSize(geometryReader.size)
                
                ZStack {
                    ClockMarks(count: 36, longDivider: 6, longTickHeight: 10 * strokeScalar, tickHeight: 5 * strokeScalar, tickWidth: 2 * strokeScalar, highlightedColorDivider: 6, highlightedColor: .primary, normalColor: .gray)
                    NumberView(numbers: Array(0..<6), textColor: .primary, font: titleFont)
                        .padding(10 * strokeScalar)
                    
                    if showDate {
                        HStack {
                            Spacer()
                            Text("\(time.dayOfMonth.asSex())")
                                .font(textFont)
                                .padding(2)
                                .padding(.horizontal, 2)
                                .border(borderColor)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    ClockHand(angle: lapseAngle, length: 0.4)
                        .stroke(Color.primary,
                                style: StrokeStyle(
                                    lineWidth: 6 * strokeScalar,
                                    lineCap: .round,
                                    lineJoin: .round))
                    
                    if useTwoHourHands {
                        ClockHand(angle: sisthLapseAngel, length: 0.56)
                            .stroke(Color.gray,
                                    style: StrokeStyle(
                                        lineWidth: 4 * strokeScalar,
                                        lineCap: .round,
                                        lineJoin: .round))
                    }
                    
                    ClockHand(angle: CGFloat(time.lull) / 36, length: 0.75)
                        .stroke(Color.blue,
                                style: StrokeStyle(
                                    lineWidth: 3 * strokeScalar,
                                    lineCap: .round,
                                    lineJoin: .round))
                    if showSecondsHand {
                        ClockHand(angle: CGFloat(time.moment) / 36, length: 0.825, backstroke: 0.125)
                            .stroke(Color.red,
                                    style: StrokeStyle(
                                        lineWidth: 2 * strokeScalar,
                                        lineCap: .round,
                                        lineJoin: .round))
                        Circle().scale(0.05).stroke(Color.red,
                                                     style: StrokeStyle(
                                                         lineWidth: 2,
                                                         lineCap: .round,
                                                         lineJoin: .round))
                        Circle().scale(0.04).colorInvert()

                    }
                }
                .frame(width: size.width, height: size.height, alignment: .center)
                
                .padding(.leading, Constraint.marginLeading)
                .padding(.trailing, Constraint.marginTrailing)
                .padding(.top, Constraint.marginTop)
                
                if showDigitally {
                    Text("\(time.lapse.asSex(padding: 2)):\(time.lull.asSex(padding: 2))")
                        .font(textFont)
                        .padding(.top, 2 * strokeScalar)
                }
            }
        }
    }
    
    func getSize(_ size: CGSize) -> CGSize {
        var width: CGFloat = 0
        
        if size.width <= size.height {
            width = size.width - Constraint.marginLeading - Constraint.marginTrailing
        } else {
            width = size.height - Constraint.marginTop
        }
        let height = showDigitally ? width - 10 : width
        return CGSize(width: width, height: height)
    }
    
}
