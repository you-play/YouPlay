//
//  YouPlayApp.swift
//  YouPlay
//
//  Created by Sebastian on 3/10/24.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
