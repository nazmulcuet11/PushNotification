//
//  UserDefaults+Extensions.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation

extension UserDefaults {
    static let suitName = "group.com.tigeritfoundation.PushNotification"
    static let apppGroup = UserDefaults(suiteName: suitName)!

    private enum Keys {
        static let badge = "badge"
    }

    var badge: Int {
        get {
            return UserDefaults.apppGroup.integer(forKey: Keys.badge)
        }
        set {
            UserDefaults.apppGroup.setValue(newValue, forKey: Keys.badge)
        }
    }
}
