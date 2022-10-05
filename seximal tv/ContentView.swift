//
//  ContentView.swift
//  seximal tv
//
//  Created by Henrik Storch on 05.10.22.
//

import SwiftUI

/*
struct RowView: View {
    var ix: Int
    @FocusState var focusedIx: Int?
    
    var isFocused: Bool { ix == focusedIx }
    
    var body: some View {
        Text("Row Index: \(ix)")
            .foregroundColor(isFocused ? .red : .blue)
    }
}
*/

struct ContentView: View {
    var time: SexTime = SexTime()
    @FocusState var focusedIx: Int?

    var body: some View {
        NavigationView {
            TabView {
                SexTimeView(time: time)
                    .tabItem { Label("Time", systemImage: "calendar") }
                TVClockView(time: time)
                    .tabItem { Label("Clock", systemImage: "clock") }
                CalculatorView()
                    .tabItem { Label("Calc", systemImage: "number.square.fill") }
                    .onAppear {
                        time.stopTimer()
                    }
                    .onDisappear {
                        time.startTimer()
                    }
            }
        }
        .onAppear {
            time.startTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
