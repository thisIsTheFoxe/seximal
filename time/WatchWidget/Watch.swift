//
//  Watch.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import Intents
import WidgetKit

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
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [WatchEntry(date: midnight, configuration: configuration)]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct WatchEntryView : View {
    var entry: WatchProvider.Entry
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    var body: some View {
//        ClockFace(date: entry.date)
        VStack {
            Text(entry.date, formatter: Self.dateFormatter)
            Text(entry.date, style: Text.DateStyle.timer)
        }
    }
}

struct Watch: Widget {
    let kind: String = "time"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WatchIntent.self, provider: WatchProvider()) { entry in
            WatchEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Watch_Previews: PreviewProvider {
    static var previews: some View {
        WatchEntryView(entry: WatchEntry(date: Date(), configuration: WatchIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
