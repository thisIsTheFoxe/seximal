//
//  WatchCalendarView.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 28.06.21.
//

import SwiftUI

struct WatchCalendarView: View {
    var time: SexTime

    var body: some View {
        ScrollView {
            MonthView(title: Text(time.month).font(.headline), spacing: 6, currentDay: time.dayOfMonth, isLast: time.monthIx == time.allMonths.count - 1)
            Text(time.format(for: .all)!)
                .padding()
        }

    }
}

struct WatchCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WatchCalendarView(time: SexTime(date: Date().addingTimeInterval(0)))
    }
}
