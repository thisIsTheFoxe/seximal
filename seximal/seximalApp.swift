//
//  seximalApp.swift
//  seximal
//
//  Created by Henrik Storch on 25.01.21.
//

import SwiftUI

@main
struct seximalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var globalState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalState)
        }
    }
}
