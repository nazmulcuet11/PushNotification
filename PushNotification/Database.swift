//
//  Database.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import Foundation
import CoreData

class Database {
    static let shared = Database()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {

        let groupName = "group.com.tigeritfoundation.PushNotification"
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupName)!
            .appendingPathComponent("DataModel.sqlite")

        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions = [
            NSPersistentStoreDescription(url: url)
        ]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
