//
//  CalendarWidget.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import Intents
import WidgetKit

struct CalendarWidget: Widget {
    let kind = "cal"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CalendarIntent.self, provider: CalendarProvider()) { entry in
            CalendarEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("A widget showing the current month and date in a seximal calendar.")
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let configuration: CalendarIntent
}

struct CalendarProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), configuration: CalendarIntent())
    }

    func getSnapshot(for configuration: CalendarIntent, in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        let entry = CalendarEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: CalendarIntent, in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        let midnight = Calendar.utc.startOfDay(for: Date())
        let nextMidnight = Calendar.utc.date(byAdding: .day, value: 1, to: midnight)!
        let next4Days = (0...3).map({ Calendar.utc.date(byAdding: .day, value: $0, to: midnight)! })
        let entries = next4Days.map({ CalendarEntry(date: $0, configuration: configuration) })
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)

    }
}

struct CalendarEntryView: View {
    var entry: CalendarProvider.Entry
    var time = SexTime()
    @Environment(\.widgetFamily) var family: WidgetFamily

    var titleFont: Font {
        switch family {
        case .systemSmall:
            return .caption
        case .systemMedium:
            return .subheadline
        default: return .title
        }
    }

    var textFont: Font {
        switch family {
        case .systemSmall:
            return .system(size: 8).bold()
        case .systemMedium:
            return .system(size: 10).bold()
        default: return .body
        }
    }

    var emptyIntent: CalendarIntent = {
        let emptyIntent = CalendarIntent()
        emptyIntent.showText = TextConfig.none
        return emptyIntent
    }()

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            HStack {
                VStack(spacing: 2) {
                    MonthView(title: Text(time.month).font(titleFont).bold(),
                              spacing: 4,
                              currentDay: time.dayOfMonth,
                              isLast: time.month == time.allMonths.last!
                    )
                    if let timeText = time.format(for: entry.configuration.showText) {
                        Text(timeText)
                            .font(textFont)
                            .bold()
                            .padding(.vertical, 2)
                    }
                }
                .padding(family == .systemSmall ? 20 : 30)

                if family == .systemMedium {
                    WeekdayEntryView(entry: .init(date: entry.date, config: emptyIntent), showText: false)
                        .scaledToFit()
                }
            }
        }
        .widgetURL(AppState.url(for: .convert, converterType: .time))
    }
}

@available(iOSApplicationExtension 15.0, *)
struct CalendarWidget_Preview: PreviewProvider {

    static var previews: some View {
//        CalendarEntryView(entry: .init(date: Date(), configuration: .preview))
//            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
        CalendarEntryView(entry: .init(date: Date(), configuration: .preview))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        CalendarEntryView(entry: .init(date: Date(), configuration: .preview))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension CalendarIntent {
    static var preview: CalendarIntent = {
        let i = CalendarIntent()
        i.showText = .all
        return i
    }()
}
