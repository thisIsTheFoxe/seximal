//
//  WeekdayWidget.swift
//  seximal
//
//  Created by Henrik Storch on 25.06.21.
//

import SwiftUI
import Intents
import WidgetKit

struct WeekdayWidget: Widget {
    static let kind = "week"
    
    var config : some WidgetConfiguration = {
        IntentConfiguration(kind: Self.kind, intent: CalendarIntent.self, provider: WeekdayProvider()) { entry in
            WeekdayEntryView(entry: entry)
        }
        .configurationDisplayName("Week Widget")
        .description("A widget showing the object after which the current day of the week is named (e.g. Sunday = Sun, Vensday = Venus).")
    }()
    
    var body: some WidgetConfiguration {
//        if #available(iOSApplicationExtension 15.0, *) {
//            return config
//                .supportedFamilies([.systemSmall, .systemLarge, .systemExtraLarge])
//        } else {
            return config
                .supportedFamilies([.systemSmall, .systemLarge])
//        }
    }
}

struct WeekdayEntry: TimelineEntry {
    let date: Date
    let config: CalendarIntent
}

struct WeekdayProvider: IntentTimelineProvider {
    var cal: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
    
    func placeholder(in context: Context) -> WeekdayEntry {
        WeekdayEntry(date: Date(), config: CalendarIntent())
    }
    func getSnapshot(for configuration: CalendarIntent, in context: Context, completion: @escaping (WeekdayEntry) -> Void) {
        completion(WeekdayEntry(date: Date(), config: configuration))
    }
    
    func getTimeline(for configuration: CalendarIntent, in context: Context, completion: @escaping (Timeline<WeekdayEntry>) -> Void) {
        let midnight = cal.startOfDay(for: Date())
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: midnight)!
        let next4Days = (0...3).map({ cal.date(byAdding: .day, value: $0, to: midnight)! })
        let entries = next4Days.map( { WeekdayEntry(date: $0, config: configuration) })
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct WeekdayEntryView : View {
    var entry: WeekdayProvider.Entry
    
    var showText: Bool = true
    
    var time: SexTime
    
    init(entry: WeekdayProvider.Entry, showText: Bool = true) {
        self.entry = entry
        self.showText = showText
        self.time = SexTime(date: entry.date)
    }
    
    var body: some View {
        ZStack {
            Image("\(time.weekday)/\(Int.random(in: 0...4))", bundle: .main)
                .resizable()
                .scaledToFill()
            if let timeText = time.format(for: entry.config.showText) {
                VStack {
                    Spacer()
                    Text(timeText)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0.5, x: 0, y: 1)
                        .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                        .shadow(color: .black, radius: 0.5, x: -1, y: 0)
                        .shadow(color: .black, radius: 0.5, x: 0, y: -1)
                        .padding(.horizontal, 6)
                }
                .padding()
            }
        }
        .widgetURL(AppState.url(for: .convert, converterType: .time))
    }
}

struct Weekday_Previews: PreviewProvider {
    static var previews: some View {
        WeekdayEntryView(entry: WeekdayEntry(date: Date().addingTimeInterval(12 * 3600 * 24), config: .preview))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
