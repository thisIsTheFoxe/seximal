//
//  time.swift
//  time
//
//  Created by Henrik Storch on 24.06.21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct timeWidgets: WidgetBundle {
    var body: some Widget {
        WatchWidget()
        WeekdayWidget()
        CalendarWidget()
    }
}

extension TextConfig {
    var isSet: Bool {
        self != .unknown && self != .none
    }
}
