//
//  NotifcationDelegate.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import UIKit
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print(#function)
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        completionHandler([.badge, .list, .banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }

        let identity = response.notification.request.content.categoryIdentifier
        if identity == NotificationCategoryIdentifier.acceptOrReject.rawValue {
            if let action = NotificationCategoryActionIdentifier(rawValue: response.actionIdentifier) {
                print(action)
            }
        }

        // opened the application from the notification
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else {
            return
        }

        let notification = response.notification
        let payload = notification.request.content.userInfo
        print("Received payload: \(payload)")
    }
}
