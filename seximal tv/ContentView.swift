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
    @State var activeTab: Int = 2 {
        willSet {
            if newValue < 0 && activeTab > 0 {
                time.startTimer()
            } else if newValue > 0 && activeTab < 0 {
                time.stopTimer()
            }
        }
    }

    var body: some View {
        NavigationView {
            TabView(selection: $activeTab) {
                SexTimeView(time: time)
                    .tabItem { Label("Time", systemImage: "calendar") }
                    .tag(-2)
                TVClockView(time: time)
                    .tabItem { Label("Clock", systemImage: "clock") }
                    .tag(-1)
                CalculatorView()
                    .tabItem { Label("Calc", systemImage: "number.square.fill") }
                    .tag(1)
                AboutView()
                    .tabItem { Label("About", systemImage: "questionmark.circle") }
                    .tag(2)
            }
        }
        .onAppear {
            time.startTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(activeTab: 0)
    }
}
