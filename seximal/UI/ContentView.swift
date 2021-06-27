//
//  ContentView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct ContentView: View {
     @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ConverterListView()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.square")
                    Text("Converter")
                }
                .tag(AppState.Tab.convert)
            CalculatorView()
                .environmentObject(Calculator())
                .tabItem {
                    Image(systemName: "number.square.fill")
                Text("Calculator")
                }
                .tag(AppState.Tab.calc)
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("About")
                }
                .tag(AppState.Tab.about)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
