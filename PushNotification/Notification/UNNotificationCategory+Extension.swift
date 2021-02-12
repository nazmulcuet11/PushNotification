//
//  UNNotificationCategory+Extension.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation
import UIKit

extension UNNotificationCategory {
    static var acceptOrReject: UNNotificationCategory {
        makeUNNotificationCategory(for: .acceptOrReject, actions: [.accept, .reject])
    }
    
    static var showMap: UNNotificationCategory {
        makeUNNotificationCategory(for: .showMap)
    }

    // MARK: - Helpers

    private static func makeUNNotificationCategory(for identifier: NotificationCategoryIdentifier, actions: [UNNotificationAction] = [], intentIdentifiers: [String] = []) -> UNNotificationCategory {

        return UNNotificationCategory(
            identifier: identifier.rawValue,
            actions: actions,
            intentIdentifiers: []
        )
    }
}
