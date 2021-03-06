//
//  GlobalHelperMethodss.swift
//  PushNotification
//
//  Created by Nazmul Islam on 12/2/21.
//

import Foundation

func onMain(_ work: @escaping () -> Void) {
    DispatchQueue.main.async(execute: work)
}

func parseHexData(_ data: Data) -> String {
    return data.reduce("") { $0 + String(format: "%02x", $1) }
}
