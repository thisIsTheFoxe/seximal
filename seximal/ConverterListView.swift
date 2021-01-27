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
//                Section(header: Text("Seximal")) {
                    NavigationLink("Numbers", destination: NumberConverterView())
                    NavigationLink("Time", destination: SexTimeView())
                    NavigationLink("Length", destination: LengthConverterView())
//                    NavigationLink("Volume", destination: Text("VOL"))
//                }
//                Section(header: Text("CCC")) {
//                    NavigationLink("Time", destination: CCCConverterView())
//                    NavigationLink("Length", destination: CCCConverterView())
//                    NavigationLink("Wheight", destination: CCCConverterView())
//                }
            }
            .navigationTitle("Converter")
        }
    }
}

struct ConverterListView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterListView()
    }
}
