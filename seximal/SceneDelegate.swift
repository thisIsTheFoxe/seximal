import UIKit
import SwiftUI
import os

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        os_log(#function)
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        os_log(#function)
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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if targetEnvironment(macCatalyst)
        let size = CGSize(width: 2560 / 2 - 112, height: 1600  / 2 - 112)
        windowScene.sizeRestrictions?.minimumSize = size
        windowScene.sizeRestrictions?.maximumSize = size
        #endif
        
        os_log(#function)
        if let item = connectionOptions.shortcutItem {
            _ = handle(shortcutItem: item)
        } else if connectionOptions.urlContexts.count > 0 {
            self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        os_log(#function)
        
        for ctx in URLContexts {
            guard ctx.url.scheme == "seximal", ctx.url.host == "app" else { continue }
            var components = ctx.url.pathComponents
            if components.first == "/" { components.removeFirst() }
            
            guard !components.isEmpty, let tab = AppState.Tab(rawValue: components.removeFirst()) else { continue }
            var converter: AppState.ConverterType?
            if !components.isEmpty { converter = .init(rawValue: components.removeFirst()) }
            
            DispatchQueue.main.async {
                AppState.global.selectedTab = tab
                AppState.global.activeConverter = converter
            }
            return
        }
    }
    
    
    fileprivate func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        os_log(#function)
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
        os_log(#function)
        let result = handle(shortcutItem: shortcutItem)
        completionHandler(result)
    }
}
