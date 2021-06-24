import UIKit
import SwiftUI
import os

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        connectingSceneSession.scene?.delegate = SceneDelegate()
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }

        #if targetEnvironment(macCatalyst)
        let size = CGSize(width: 2560 / 2 - 112, height: 1600  / 2 - 112)
        scene.sizeRestrictions?.minimumSize = size
        scene.sizeRestrictions?.maximumSize = size
        #endif
        
        print(#function)
        if let item = connectionOptions.shortcutItem {
            _ = handle(shortcutItem: item)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(#function)
        DispatchQueue.main.async {
            AppState.global.selectedTab = .convert
            AppState.global.activeConverter = .time
        }
    }
    
    
    fileprivate func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        print(#function)
        if shortcutItem.type == "time" {
            DispatchQueue.main.async {
                AppState.global.selectedTab = .convert
                AppState.global.activeConverter = .time
            }
            return true
        } else if shortcutItem.type == "calc" {
            DispatchQueue.main.async {
                AppState.global.selectedTab = .calc
            }
            return true
        } else {
            return false
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let result = handle(shortcutItem: shortcutItem)
        completionHandler(result)
    }
}
