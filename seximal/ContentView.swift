//
//  ContentView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 3
    
    var body: some View {
        TabView(selection: $selection) {
            ConverterListView()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.square")
                    Text("Converter")
                }
                .tag(1)
            CalculaturView()
                .environmentObject(Calculator())
                .tabItem {
                    Image(systemName: "number.square.fill")
                Text("Calculator")
                }
                .tag(2)
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("About")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
