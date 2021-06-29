//
//  WatchContentView.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import SwiftUI

struct WatchContentView: View {
    @ObservedObject var time = SexTime()
    @ObservedObject var state = WatchState.shared
    
    var body: some View {
        List {
            if #available(watchOSApplicationExtension 8.0, *) {
                NavigationLink(isActive: $state.showTime) {
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
            } else {
                NavigationLink(destination: WatchClockView(time: time), isActive: $state.showTime, label: {
                    Label("Clock", systemImage: "clock")
                })
                NavigationLink(destination: WatchCalendarView(time: time), label: {
                    Label("Calendar", systemImage: "calendar")
                })
                NavigationLink(destination: WatchCalculatorView().environmentObject(Calculator()), label: {
                    Label("Calculator", systemImage: "number.square")
                })
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
