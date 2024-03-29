//
//  SexTimeView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI
import Combine

struct SexTimeView: View {
#if os(tvOS)
    var columns = { Array(repeating: GridItem(spacing: 6), count: 5) }()
#else
    var columns = { Array(repeating: GridItem(spacing: 6), count: 2) }()
#endif

    @ObservedObject var time = SexTime()
    var timeString: String {
        "\(time.lapse.asSex()) lapse(s), \(time.lull.asSex()) lull(s), \(time.moment.asSex()) moment(s), \(time.snap.asSex()) snap(s)"
    }

    @FocusState var focusedMonthIx: Int?

    var body: some View {
        ScrollView {
            Text("Current universal time:")
                .font(.title)
            Text("(there are no time zones in seximal)")
                .font(.caption)

            Text("\(time.lapse.asSex(padding: 2)):\(time.lull.asSex(padding: 2)):\(time.moment.asSex(padding: 2)).\(time.snap)")
                .font(.title2.monospacedDigit())
                .padding(.top)
            Text(timeString)
                .font(.caption.monospacedDigit())
                .padding(4)
            Text("or")
                .padding(12)
            HStack(spacing: 0) {
                Text("\(time.span.asSex(padding: 3))")
                    .transition(.verticalSlide)
                    .id("SexTimeView.SPAN-\(time.span)")
                Text(" span(s)")
            }
            .font(.title3)
            Text("1 Span is a little less than 11 (DEC7) minutes")
                .font(.subheadline)
                .padding(4)

            Text("Check the number converter for how to pronounce seximal numbers.")
                .font(.footnote)
                .padding()
            Divider()
                .padding()
            VStack {
                Text("Today is \(time.weekday), the \(time.ordDay) of \(time.month)")
                    .padding(.bottom)
                HStack {
                    Text("Year ")
                    Text(time.year.asNif()).bold()
                        .transition(AnyTransition.opacity.combined(with: .scale(scale: 10)))
                        .id("SexTimeView.YEAR-\(time.year)")
                }
                .font(.title2)
                LazyVGrid(columns: columns, spacing: 36, content: {
                    ForEach(0..<time.allMonths.count - 1) { monthIx in
                        let monthDay = time.dayOfYear - monthIx * 36
                        MonthView(
                            focusedMonth: $focusedMonthIx, monthIx: monthIx,
                            title: Text(time.allMonths[monthIx]).font(.headline),
                            currentDay: monthDay,
                            isLast: false)
                        #if os(tvOS)
                        .focusable()
                        .focused($focusedMonthIx, equals: monthIx)
                        #endif
                    }
                })
                .padding(6)
                .padding(.bottom)
                MonthView(
                    focusedMonth: $focusedMonthIx, monthIx: time.allMonths.count,
                    title: Text(time.allMonths.last!).font(.headline),
                    currentDay: time.dayOfYear - 360,
                    isLast: true)
                    .padding(.horizontal, 75)
#if os(tvOS)
                    .focusable()
                    .focused($focusedMonthIx, equals: time.allMonths.count)
#endif
            }
            .padding(.bottom)
        }
        .navigationTitle("Time in Seximal")
#if !os(tvOS)
        .onAppear { self.time.startTimer() }
        .onDisappear { self.time.stopTimer() }
#endif
    }
}

struct SexTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SexTimeView(time: SexTime(date: Date().addingTimeInterval(-2400 * 24 * 165)))
    }
}
