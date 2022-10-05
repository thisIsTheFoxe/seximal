//
//  TVClockView.swift
//  seximal tv
//
//  Created by Henrik Storch on 05.10.22.
//

import SwiftUI

struct TVClockView: View {
    @ObservedObject var time: SexTime

    @State var showDate: Bool = false
    @State var showTwoHourHands: Bool = false
    @State var showDigitally: Bool = false
    @State var showSecondsHand: Bool = true

    var body: some View {
        HStack {
            ClockView(
                isSmall: false,
                showDate: $showDate,
                useTwoHourHands: $showTwoHourHands,
                showDigitally: $showDigitally,
                showSecondsHand: $showSecondsHand,
                titleFont: .title,
                textFont: .body,
                time: time)
            VStack {
                Toggle("Show Date", isOn: $showDate)
                Toggle("Use Two Hour Hands", isOn: $showTwoHourHands)
                Toggle("Show Digitally", isOn: $showDigitally)
                Toggle("Show Moments", isOn: $showSecondsHand)
            }
        }
    }
}

struct TVClockView_Previews: PreviewProvider {
    static var previews: some View {
        TVClockView(time: SexTime())
    }
}
