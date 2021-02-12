//
//  AppDelegate.swift
//  PushNotification
//
//  Created by Nazmul Islam on 12/2/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNotificationPermission(for: application)

        return true
    }

    // MARK: - Remote Notification

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenStr = parseHexData(deviceToken)
        print("Registered successfully for remote notification. Device Token: \(tokenStr)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notification, error: \(error.localizedDescription)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Helpers

    private func requestNotificationPermission(for application: UIApplication) {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.badge, .alert, .sound],
                completionHandler: {
                    self.notificationPermissionHandler(application, granted: $0, error: $1)
                })
    }

    private func notificationPermissionHandler(_ application: UIApplication, granted: Bool, error: Error?) {
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
            return
        }

        print("Notifacation permission granted: \(granted)")

        if granted {
            onMain(application.registerForRemoteNotifications)
        }
    }
}

