//
//  seximalWatchApp.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import SwiftUI
import WatchKit

class WatchState: NSObject, ObservableObject {
    @Published var showTime = false
    private override init() { }

    static var shared = WatchState()
}

@main
struct seximalWatchApp: App {
    @WKExtensionDelegateAdaptor(WatchDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                WatchContentView()
            }
        }
    }
}
