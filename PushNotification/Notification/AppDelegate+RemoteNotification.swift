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
            [weak self] (granted, error) in
            guard let self = self else { return }

            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
                return
            }

            print("Notifacation permission granted: \(granted)")

            if granted {
                notificationCenter.delegate = self.notificationDelegate
                self.registerCustomNotificationActions()
                onMain(application.registerForRemoteNotifications)
            }
        }
    }

    // MARK: - Remote Notification Registration Delegate

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenStr = parseHexData(deviceToken)
        print("Registered successfully for remote notification. Device Token: \(tokenStr)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notification, error: \(error.localizedDescription)")
    }

    // MARK: - Remote Notification Deleage

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print(#function)
        print(userInfo)
        
        guard let data = userInfo["data"] as? [String: Any],
              let imageURLStr = data["image_url"] as? String,
              let imageURL = URL(string: imageURLStr),
              let imageName = data["image_name"] as? String
        else {
            completionHandler(.noData)
            return
        }

        do {
            let imageData = try Data(contentsOf: imageURL)
            print("Downloaded \(imageName), Size: \(imageData.count) bytes")
            completionHandler(.newData)
        } catch {
            print("Failed to download data from: \(imageURL.path)")
            completionHandler(.failed)
        }
    }

    // MARK: - Helpers
    
    private func registerCustomNotificationActions() {
        let accept = makeUNNotificationAction(for: .accept)
        let reject = makeUNNotificationAction(for: .reject)
        let acceptReject = makeUNNotificationCategory(for: .acceptOrReject, actions: [accept, reject])

        let comment = makeUNNotificationAction(for: .comment)
        let showMap = makeUNNotificationCategory(for: .showMap, actions: [comment])

        UNUserNotificationCenter.current()
            .setNotificationCategories([acceptReject, showMap])
    }

    private func makeUNNotificationAction(for identifier: NotificationCategoryActionIdentifier) -> UNNotificationAction {

        switch identifier {
        case .accept, .reject:
            return UNNotificationAction(
                identifier: identifier.rawValue,
                title: identifier.title
            )
        case .comment:
            return UNTextInputNotificationAction(
                identifier: identifier.rawValue,
                title: identifier.title
            )
        }

    }
    
    private func makeUNNotificationCategory(for identifier: NotificationCategoryIdentifier, actions: [UNNotificationAction] = [], intentIdentifiers: [String] = []) -> UNNotificationCategory {

        return UNNotificationCategory(
            identifier: identifier.rawValue,
            actions: actions,
            intentIdentifiers: []
        )
    }
}
