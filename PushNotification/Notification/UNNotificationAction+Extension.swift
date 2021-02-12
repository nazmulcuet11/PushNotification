//
//  UNNotificationAction+Extension.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation
import UIKit

extension UNNotificationAction {
    static var accept: UNNotificationAction { makeUNNotificationAction(for: .accept) }
    static var reject: UNNotificationAction { makeUNNotificationAction(for: .reject) }
    static var cancel: UNNotificationAction { makeUNNotificationAction(for: .cancel) }
    static var comment: UNNotificationAction { makeUNNotificationAction(for: .comment) }

    // MARK: - Helpers

    private static func makeUNNotificationAction(for identifier: NotificationCategoryActionIdentifier) -> UNNotificationAction {
        switch identifier {
        case .accept, .reject, .cancel:
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
}
