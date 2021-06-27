//
//  time.swift
//  time
//
//  Created by Henrik Storch on 24.06.21.
//

import WidgetKit
import SwiftUI

@main
struct timeWidgets: WidgetBundle {
    var body: some Widget {
        WatchWidget()
        WeekdayWidget()
        CalendarWidget()
    }
}
