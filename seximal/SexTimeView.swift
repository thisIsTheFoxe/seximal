//
//  SexTimeView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI
import Combine

struct SexTimeView: View {
    
    var cal: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()
    
    @State var date = Date()
    
    @State
    private var timerSubscription: Cancellable? = nil
    
    var msSinceDay: Int {
        Int(date.timeIntervalSince(cal.startOfDay(for: date)) * 1000)  // milliseconds since midnight
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
    
    var body: some View {
        VStack {
            Text("Current universal time:")
                .font(.title)
            Text("(there are no time zones in seximal)")
                .font(.caption)
            Text("\(lapse.asSex(padding: 2)):\(lull.asSex(padding: 2)):\(moment.asSex(padding: 2)).\(snap)")
                .font(.title2)
                .padding()
            Text("Pronounciation:")
                .font(.headline)
            Text("\(lapse.asSex()) lapse, \(lull.asSex()) lull, \(moment.asSex()) moment(s), \(snap.asSex()) snap(s)")
            Text("Check the number converter for how to pronounce numbers.")
                .font(.footnote)
                .padding(4)
        }
        .padding()
        .navigationTitle("Time in Seximal")
        .onAppear { self.subscribe() }
        .onDisappear { self.unsubscribe() }
    }
    
    private func subscribe() {
        timerSubscription =
            Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .assign(to: \.date, on: self)
    }
    
    private func unsubscribe() {
        timerSubscription?.cancel()
    }
}

struct SexTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SexTimeView()
    }
}
