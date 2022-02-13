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
    func handleUserActivity(_ userInfo: [AnyHashable: Any]?) {
        if userInfo?[CLKLaunchedComplicationIdentifierKey] != nil {
            WatchState.shared.showTime = true
        }
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print(#function, backgroundTasks.debugDescription)
        defer {
            backgroundTasks.forEach({ $0.setTaskCompletedWithSnapshot(false) })
        }

        guard backgroundTasks.contains(where: { $0 is WKSnapshotRefreshBackgroundTask }) else {
            return print("No refresh task!")
        }

        updateComplications()

        scheduleBackgroundRefreshTasks()
    }
}

func scheduleBackgroundRefreshTasks() {

    print("Scheduling a background task.")

    // Get the shared extension object.
    let watchExtension = WKExtension.shared()

    // If there is a complication on the watch face
    // updates once per lapse.
    let targetDate = Date().addingTimeInterval(24 * 100)

    // Schedule the background refresh task.
    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil) { (error) in

        // Check for errors.
        if let error = error {
            print("An error occurred while scheduling a background refresh task: \(error.localizedDescription)")
            return
        }

        print("Task scheduled!")
    }
}

func updateComplications() {
    for comp in CLKComplicationServer.sharedInstance().activeComplications ?? [] {
        CLKComplicationServer.sharedInstance().reloadTimeline(for: comp)
    }
}
