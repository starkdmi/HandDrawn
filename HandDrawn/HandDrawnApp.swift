//
//  HandDrawnApp.swift
//  HandDrawn
//
//  Created by Dmitry Starkov on 10/10/2022.
//

import SwiftUI

// TODO: (BUG) Scalled with fingers text view has incorect info and can overflow parent or can't move to the border - even with disabled pinchGesture (!) - get transformed bounds
// TODO: (BUG) ClearAll didn't cancel lasso selection
// TODO: (FEATURE) Native swiftui alert with multiline textfield

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
                
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: PermissionsView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
}
