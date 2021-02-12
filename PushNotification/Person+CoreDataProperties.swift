//
//  Person+CoreDataProperties.swift
//  PushNotification
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}

extension Person : Identifiable {

}
