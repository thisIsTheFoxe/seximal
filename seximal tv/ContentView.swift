//
//  ContentView.swift
//  seximal tv
//
//  Created by Henrik Storch on 05.10.22.
//

import SwiftUI

struct ContentView: View {
    var time: SexTime = SexTime()

    var body: some View {
        NavigationView {
            TabView {
                SexTimeView(time: time)
                    .tabItem { Label("Time", systemImage: "calendar") }
                TVClockView(time: time)
                .tabItem { Label("Clock", systemImage: "clock") }
                CalculatorView()
                    .tabItem { Label("Calc", systemImage: "number.square.fill") }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
