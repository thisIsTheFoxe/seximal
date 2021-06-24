//
//  ClockFace.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import SwiftUI
import Combine

struct ClockHand: Shape {
    let angle: CGFloat
    let length: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = (rect.width / 2) * self.length
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.move(to: center)
        
        let hoursAngle = CGFloat.pi / 2 - .pi * 2 * angle
        
        path.addLine(to: CGPoint(
            x: rect.midX + cos(hoursAngle) * length,
            y: rect.midY - sin(hoursAngle) * length))
        return path
    }
}

struct ClockFace: View {
    
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
    
    var moment: Double {
        var htime = Double(msSinceDay) / 2400000 // hexHours
        htime = (htime - Double(lapse)) * 36 // hexMinutes
        htime = (htime - Double(lull)) * 36 // hexSeconds
        return htime
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
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geometryReader in
                VStack {
                    let width = geometryReader.size.width - Constraint.marginLeading - Constraint.marginTrailing
                    
                    ZStack {
                        ClockMarks(count: 36, longDivider: 6, longTickHeight: 10, tickHeight: 5, tickWidth: 2, highlightedColorDivider: 6, highlightedColor: .primary, normalColor: .gray)
                        NumberView(numbers: Array(0..<6), textColor: .primary, font: .headline)
                            .padding(10)
                        ClockHand(angle: CGFloat(0) / 36, length: 0.5)
                            .stroke(Color.primary,
                                    style: StrokeStyle(
                                        lineWidth: 5,
                                        lineCap: .round,
                                        lineJoin: .round))
                        ClockHand(angle: CGFloat(9) / 36, length: 0.7)
                            .stroke(Color.blue,
                                    style: StrokeStyle(
                                        lineWidth: 4,
                                        lineCap: .round,
                                        lineJoin: .round))
                        ClockHand(angle: CGFloat(moment) / 36, length: 0.9)
                            .stroke(Color.red,
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        lineCap: .round,
                                        lineJoin: .round))
                    }.frame(width: width, height: width - 10, alignment: .center)
//
                    .padding(.leading, Constraint.marginLeading)
                    .padding(.trailing, Constraint.marginTrailing)
                    .padding(.top, Constraint.marginTop)
                    
                    Text("\(lapse.asSex(padding: 2)):\(lull.asSex(padding: 2)):\(moment.asSexInt(padding: 2)).\(snap)")
                        .font(.caption)
                }
            }
        }
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

struct ClockFace_Previews: PreviewProvider {
    static var previews: some View {
        ClockFace()
            .colorScheme(.dark)
    }
}
