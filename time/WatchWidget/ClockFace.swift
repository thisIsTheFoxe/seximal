//
//  ClockFace.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import WidgetKit

struct ClockFace: View {
    var config: WatchIntent
    var time: SexTime
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var textFont: Font {
        switch family {
        case .systemSmall:
            return .system(size: 8).bold()
        case .systemMedium:
            return .system(size: 10).bold()
        default: return .body
        }
    }
    
    var titleFont: Font {
        switch family {
        case .systemSmall:
            return .caption
        case .systemMedium:
            return .subheadline
        default: return .title
        }
    }
    
    var body: some View {
        ClockView(
            isSmall: family == .systemSmall,
            showDate: config.showDate == true,
            useTwoHourHands: config.useTwoHourHands == true,
            showDigitally: config.showDigitally == true,
            showSecondsHand: false,
            titleFont: titleFont,
            textFont: textFont,
            time: time)
    }
}

struct ClockFace_Preview: PreviewProvider {
    static var previews: some View {
        ClockFace(config: .preview, time: SexTime(date: Date().addingTimeInterval(60*370)))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
