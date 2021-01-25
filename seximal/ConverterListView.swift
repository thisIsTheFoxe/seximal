//
//  ConverterListView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct ConverterListView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Seximal")) {
                    NavigationLink("Numbers", destination: NumberConverterView())
                    NavigationLink("Time", destination: Text("TIMEE"))
                    NavigationLink("Temperature", destination: Text("TEMP"))
                    NavigationLink("Length", destination: Text("LEN"))
                    NavigationLink("Volume", destination: Text("VOL"))
                }
                NavigationLink("CCC", destination: CCCConverterView())
            }
        }
    }
}

struct ConverterListView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterListView()
    }
}
