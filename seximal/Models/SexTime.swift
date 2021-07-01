//
//  SexTime.swift
//  seximal
//
//  Created by Henrik Storch on 26.06.21.
//

import Foundation
import Combine
import Intents

extension Calendar {
    static let utc: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
}


class SexTime: ObservableObject {
    init(date: Date = Date()) {
        self.date = date
        self.dayDate = date
    }
    
    var dayOfYear: Int {
        //day / year doesn't update
        Calendar.utc.ordinality(of: .day, in: .year, for: dayDate) ?? -1
    }
    
    var monthIx : Int { (dayOfYear - 1) / 36 }
    
    var dayOfMonth: Int {
        dayOfYear - monthIx * 36
    }
    
    var ordDay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let sexDayAsInt = Int(dayOfMonth.asSex()) ?? 0
        return formatter.string(from: sexDayAsInt as NSNumber) ?? ""
    }
    
    @Published var date: Date
    
    @Published var dayDate: Date
    
    @Published
    var timerSubscription: Cancellable? = nil
    
    var msSinceDay: Int {
        Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)) * 1000)  // milliseconds since midnight
    }
    
    var shortTime: String { "\(lapse.asSex(padding: 2)):\(lull.asSex(padding: 2))" }
    
    var lapse: Int {
        msSinceDay / 2400000
    }
        
    var lull: Int {
        var htime = Double(msSinceDay) / 2400000 // hexHours
        htime = (htime - Double(lapse)) * 36 // hexMinutes
        return Int(htime)
    }
    
    var moment: Int {
        var htime = Double(msSinceDay) / 2400000 // hexHours
        htime = (htime - Double(lapse)) * 36 // hexMinutes
        htime = (htime - Double(lull)) * 36 // hexSeconds
        return Int(htime)
    }
    
    var snap: Int {
        var htime = Double(msSinceDay) / 2400000 // hexHours
        htime = (htime - Double(lapse)) * 36 // hexMinutes
        htime = (htime - Double(lull)) * 36 // hexSeconds
        htime = (htime - Double(moment)) * 6
        return Int(htime)
    }
    
    var span: Int {
        lull / 6 + lapse * 6
    }
    
    var month: String {
        allMonths[monthIx]
    }
    
    var weekday: String {
        Self.allWeekdays[(dayOfYear - 1) % 6]
    }
    
    var shortWeekday: String {
        Self.allWeekdaysShort[(dayOfYear - 1) % 6].uppercased()
    }
    
    var allMonths: [String] = {
        var result = Calendar.current.monthSymbols
        result.removeSubrange(6...7)
        result.append("New Year's Week")
        return result
    }()
    
    static let allWeekdays: [String] = ["Sunday", "Monday", "Vensday", "Marsday", "Joday", "Saturday"]
    static let allWeekdaysShort: [String] = ["Sun", "Mon", "Ves", "Mar", "Jo", "Sat"]

    func format(for config: TextConfig) -> String? {
        switch config {
        case .all:
            return "\(weekday), \(month) \(ordDay)"
        case .month:
            return month
        case .monthDay:
            return "\(month) \(ordDay)"
        case .weekday:
            return weekday
        default:
            return nil
        }
    }
    
    func startTimer() {
        print(#function)
        self.timerSubscription =
            Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .map({
                if !Calendar.utc.isDate($0, inSameDayAs: self.dayDate) {
                    self.dayDate = $0
                }
                return $0
            })
            .assign(to: \.date, on: self)
    }
    
    func stopTimer() {
        print(#function)
        self.timerSubscription?.cancel()
    }
}
