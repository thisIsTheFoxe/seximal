//
//  WatchWidget.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import Intents
import WidgetKit

struct WatchWidget: Widget {
    let kind: String = "time"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WatchIntent.self, provider: WatchProvider()) { entry in
            WatchEntryView(entry: entry)
        }
        .configurationDisplayName("Watch Widget")
        .description("A widget displaying the time in seximal.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct WatchEntry: TimelineEntry {
    let date: Date
    let configuration: WatchIntent
}

struct WatchProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> WatchEntry {
        WatchEntry(date: Date(), configuration: WatchIntent())
    }

    func getSnapshot(for configuration: WatchIntent, in context: Context, completion: @escaping (WatchEntry) -> ()) {
        let entry = WatchEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: WatchIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print(#function)
        
        let secondsInAMoment = ((60.0 * 60.0 * 24.0) / (36.0 * 36.0 * 36.0))
        let secondsInALapse = secondsInAMoment * 36
        let date = Date()
        
        let secondsSinceDay = Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)))
        let momentsSinceDay = Double(secondsSinceDay) / secondsInAMoment
        
        //TODO: start from current lull, to avoid unneccisary waiting / loading
        let lullsSinceDay = Int(momentsSinceDay / 36) + 1
        let nextLullInSec = Double(lullsSinceDay) * 36 * secondsInAMoment + 0.25
        
        let now = Calendar.utc.startOfDay(for: date).addingTimeInterval(nextLullInSec)
        
        
        var entries = [WatchEntry(date: now.addingTimeInterval(-secondsInALapse), configuration: WatchIntent())]
        
//        var entries = [WatchEntry(date: Date().addingTimeInterval(3), configuration: WatchIntent())]
        
        for i in 0..<(36 * 6) {
            entries.append(WatchEntry(date: now.addingTimeInterval(TimeInterval(Double(i) * secondsInALapse)), configuration: configuration))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct WatchEntryView : View {
    var entry: WatchProvider.Entry
    
    var body: some View {
        ClockFace(config: entry.configuration, time: SexTime(date: entry.date))
            .widgetURL(AppState.url(for: .convert, converterType: .time))
    }
}

struct Watch_Previews: PreviewProvider {
    static var previews: some View {
        WatchEntryView(entry: WatchEntry(date: Date(), configuration: .preview))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        WatchEntryView(entry: WatchEntry(date: Date(), configuration: .preview))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


extension WatchIntent {
    static var preview: WatchIntent = {
        let i = WatchIntent()
        i.showDate = true
        i.showDigitally = true
        i.useTwoHourHands = true
        return i
    }()
}
