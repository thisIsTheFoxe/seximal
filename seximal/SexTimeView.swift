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
    
    var span: Int {
        lull / 6 + lapse * 6
    }
    
    var body: some View {
        VStack {
            Text("Current universal time:")
                .font(.title)
            Text("(there are no time zones in seximal)")
                .font(.caption)
            
            Text("\(lapse.asSex(padding: 2)):\(lull.asSex(padding: 2)):\(moment.asSex(padding: 2)).\(snap)")
                .font(.title2)
                .padding(.top)
            Text("\(lapse.asSex()) lapse, \(lull.asSex()) lull, \(moment.asSex()) moment(s), \(snap.asSex()) snap(s)")
                .padding(4)
            Text("or")
                .padding(12)
            Text("\(span.asSex(padding: 3)) span(s)")
                .font(.title2)
            Text("1 Span is a little less than 11 (DEC7) minutes")
                .font(.subheadline)
                .padding(4)
            
            Text("Check the number converter for how to pronounce seximal numbers.")
                .font(.footnote)
                .padding()
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
