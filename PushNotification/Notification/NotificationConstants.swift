//
//  NotificationCategoryIdentifiers.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation

enum NotificationCategoryIdentifier: String {
    case acceptOrReject = "AcceptOrReject"
    case showMap = "ShowMap"
}

enum NotificationCategoryActionIdentifier: String {
    case accept, reject

    var title: String {
        switch self {
        case .accept: return "Accept"
        case .reject: return "Reject"
        }
    }
}
