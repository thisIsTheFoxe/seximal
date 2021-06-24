//
//  AppState.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var selectedTab: ContentView.Tab = .about
    @Published var activeConverter: ConverterListView.ConverterType?
    
    static let global = AppState()
    
    private init() { }
}

extension ConverterListView {
    enum ConverterType: Hashable {
        case time, length, number
    }
}

extension ContentView {
    enum Tab: Hashable {
        case convert
        case calc
        case about
    }
}
