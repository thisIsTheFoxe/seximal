//
//  WatchClockView.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import SwiftUI

struct WatchClockView: View {
    @State var showTwoHourHands = false
    @ObservedObject var time: SexTime
    var body: some View {
        VStack {
            ClockView(
                isSmall: true,
                showDate: false,
                useTwoHourHands: showTwoHourHands,
                showDigitally: false,
                showSecondsHand: true,
                titleFont: .caption,
                textFont: .system(size: 8).bold(),
                time: time)
            
            Text("\(time.lapse.asSex(padding: 2)):\(time.lull.asSex(padding: 2)):\(time.moment.asSex(padding: 2)).\(time.snap.asSex())")
                .font(.system(size: 10).bold())
                .padding(.bottom, 1)
        }.ignoresSafeArea()
            .onAppear { time.startTimer() }
            .onDisappear { time.stopTimer() }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        WatchClockView(time: SexTime())
    }
}
