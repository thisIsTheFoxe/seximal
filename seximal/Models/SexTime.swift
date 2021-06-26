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
    var dayOfYear: Int {
        //day / year doesn't update
        Calendar.utc.ordinality(of: .day, in: .year, for: dayDate) ?? -1
    }
    
    var ordDay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let month = (dayOfYear - 1) / 36
        let seximalDay = (dayOfYear - month * 36).asSex() //FIXME: not in dec
        let sexDayAsInt = Int(seximalDay) ?? 0
        return formatter.string(from: sexDayAsInt as NSNumber) ?? ""
    }
    
    @Published var date = Date()
    
    @Published var dayDate = Date()
    
    @Published
    var timerSubscription: Cancellable? = nil
    
    var msSinceDay: Int {
        Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)) * 1000)  // milliseconds since midnight
    }
    
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
    
    var monthIx : Int { (dayOfYear - 1) / 36 }
    
    var weekday: String {
        allWeekdays[(dayOfYear - 1) % 6]
    }
    
    var allMonths: [String] = {
        var result = Calendar.current.monthSymbols
        result.removeSubrange(6...7)
        result.append("New Year's Week")
        return result
    }()
    
    let allWeekdays: [String] = ["Sunday", "Monday", "Vensday", "Marsday", "Joday", "Saturday"]

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
}
