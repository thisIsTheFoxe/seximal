//
//  WatchContentView.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import SwiftUI

struct WatchContentView: View {
    @ObservedObject var time = SexTime()
    
    var body: some View {
        List {
            NavigationLink {
                WatchClockView(time: time)
            } label: {
                Label("Clock", systemImage: "clock")
            }
            NavigationLink {
                WatchCalendarView(time: time)
            } label: {
                Label("Calendar", systemImage: "calendar")
            }
            NavigationLink {
                WatchCalculatorView()
                    .environmentObject(Calculator())
            } label: {
                Label("Calculator", systemImage: "number.square")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchContentView()
        }
    }
}
