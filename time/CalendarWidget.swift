//
//  CalendarWidget.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import Intents
import WidgetKit


@main
struct CalendarWidget: Widget {
    let kind = "calendar"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CalendarIntent.self, provider: CalendarProvider()) { entry in
            CalendarEntryView(entry: entry)
        }
    }
}

struct CalendarProvider: IntentTimelineProvider {
    
    var cal: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
    
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), configuration: CalendarIntent())
    }
    
    func getSnapshot(for configuration: CalendarIntent, in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        let entry = CalendarEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: CalendarIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let midnight = cal.startOfDay(for: Date())
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: midnight)!
        let next4Days = (1...3).map({ cal.date(byAdding: .day, value: $0, to: midnight)! })
        let entries = next4Days.map( { CalendarEntry(date: $0, configuration: configuration) })
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)

    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let configuration: CalendarIntent
}

struct CalendarEntryView: View {
    var entry: CalendarProvider.Entry
    
    var dayOfYear: Int {
        //day / year doesn't update
        cal.ordinality(of: .day, in: .year, for: entry.date) ?? -1
    }
    
    var cal: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
    
    var months: [String] = {
        var result = Calendar.current.monthSymbols
        result.removeSubrange(6...7)
        result.append("New Year's Week")
        return result
    }()
    
    let weekDays: [String] = ["Sunday", "Monday", "Vensday", "Marsday", "Joday", "Saturday"]
    
    var monthIx: Int {
        (dayOfYear - 1) / 36
    }
    
    var ordDay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let month = (dayOfYear - 1) / 36
        let seximalDay = (dayOfYear - month * 36).asSex() //FIXME: not in dec
        let sexDayAsInt = Int(seximalDay) ?? 0
        return formatter.string(from: sexDayAsInt as NSNumber) ?? ""
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 2) {
                MonthView(title: Text(months[monthIx]).font(.caption).bold(),
                          spacing: 2,
                          currentDay: dayOfYear - monthIx * 36,
                          isLast: monthIx == months.count - 1
                )
                if entry.configuration.showDate?.boolValue == true {
                    Text("\(weekDays[(dayOfYear - 1) % 6]), \(months[(dayOfYear - 1) / 36]) \(ordDay)")
                        .font(.system(size: 8))
                        .bold()
                        .padding(.vertical, 2)
                }
            }
            .padding(20)
        }
        .widgetURL(URL(string: "seximal://Converter/Time"))
    }
}
