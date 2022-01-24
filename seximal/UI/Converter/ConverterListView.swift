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
                NavigationLink(
                    "Numbers",
                    destination: NumberConverterView(),
                    tag: .number,
                    selection: $appState.activeConverter)
                NavigationLink("Time", destination: SexTimeView(), tag: .time, selection: $appState.activeConverter)
                NavigationLink(
                    "Length",
                    destination: LengthConverterView(),
                    tag: .length,
                    selection: $appState.activeConverter)
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
