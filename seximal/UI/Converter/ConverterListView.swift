//
//  ConverterListView.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

struct ConverterListView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            List {
//                Section(header: Text("Seximal")) {
                NavigationLink("Numbers", destination: NumberConverterView(), tag: .number, selection: $appState.activeConverter)
                    NavigationLink("Time", destination: SexTimeView(), tag: .time, selection: $appState.activeConverter)
                    NavigationLink("Length", destination: LengthConverterView(), tag: .length, selection: $appState.activeConverter)
//                    NavigationLink("Volume", destination: Text("VOL"))
//                }
//                Section(header: Text("CCC")) {
//                    NavigationLink("Time", destination: CCCConverterView())
//                    NavigationLink("Length", destination: CCCConverterView())
//                    NavigationLink("Weight", destination: CCCConverterView())
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
