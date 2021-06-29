//
//  WatchDelegate.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 28.06.21.
//

import Foundation
import ClockKit
import WatchKit

class WatchDelegate: NSObject, WKExtensionDelegate {
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        if (userInfo?[CLKLaunchedComplicationIdentifierKey] != nil) {
            WatchState.shared.showTime = true
        }
    }
}
