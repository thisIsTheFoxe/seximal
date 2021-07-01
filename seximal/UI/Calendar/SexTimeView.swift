//
//  SexTimeView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI
import Combine

struct SexTimeView: View {
    
    var columns = { Array(repeating: GridItem(spacing: 6), count: 2) }()
    
    @ObservedObject var time = SexTime()
    
    var body: some View {
        ScrollView {
            Text("Current universal time:")
                .font(.title)
            Text("(there are no time zones in seximal)")
                .font(.caption)
            
            Text("\(time.lapse.asSex(padding: 2)):\(time.lull.asSex(padding: 2)):\(time.moment.asSex(padding: 2)).\(time.snap)")
                .font(.title2)
                .padding(.top)
            Text("\(time.lapse.asSex()) lapse, \(time.lull.asSex()) lull, \(time.moment.asSex()) moment(s), \(time.snap.asSex()) snap(s)")
                .padding(4)
            Text("or")
                .padding(12)
            Text("\(time.span.asSex(padding: 3)) span(s)")
                .font(.title2)
            Text("1 Span is a little less than 11 (DEC7) minutes")
                .font(.subheadline)
                .padding(4)
            
            Text("Check the number converter for how to pronounce seximal numbers.")
                .font(.footnote)
                .padding()
            Divider()
            VStack {
                Text("Today is \(time.weekday), the \(time.ordDay) of \(time.month) ")
                    .padding()
                LazyVGrid(columns: columns, spacing: 36, content: {
                    ForEach(0..<time.allMonths.count - 1) { monthIx in
                        let monthDay = time.dayOfYear - monthIx * 36
                        MonthView(
                            title: Text(time.allMonths[monthIx]).font(.headline),
                            currentDay: monthDay,
                            isLast: false)
                    }
                })
                .padding(6)
                .padding(.bottom)
                MonthView(
                    title: Text(time.allMonths.last!).font(.headline),
                    currentDay: time.dayOfYear - 360,
                    isLast: true)
                    .padding(.horizontal, 75)
            }
            .padding(.bottom)
        }
        .navigationTitle("Time in Seximal")
        .onAppear { self.time.startTimer() }
        .onDisappear { self.time.stopTimer() }
    }
}

struct SexTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SexTimeView(time: SexTime(date: Date().addingTimeInterval(-2400 * 24 * 165)))
    }
}
