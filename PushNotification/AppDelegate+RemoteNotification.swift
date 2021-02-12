//
//  AppDelegate+RemoteNotification.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation
import UIKit

extension AppDelegate {

    func registerForRemoteNotification(for application: UIApplication) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) {
            (granted, error) in

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

    // MARK: - Remote Notification Delegate

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenStr = parseHexData(deviceToken)
        print("Registered successfully for remote notification. Device Token: \(tokenStr)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notification, error: \(error.localizedDescription)")
    }
}
