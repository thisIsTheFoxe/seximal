//
//  ContentView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ConverterListView()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.square")
                    Text("Converter")
                }
            CalculaturView()
                .environmentObject(Calculator())
                .tabItem {
                    Image(systemName: "number.square.fill")
                Text("Calculator")
                }
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("About")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
