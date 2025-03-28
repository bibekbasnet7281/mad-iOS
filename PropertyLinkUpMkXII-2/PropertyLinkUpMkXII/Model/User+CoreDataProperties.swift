//
//  User+CoreDataProperties.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var gender: String?
    @NSManaged public var userrole: String?
    @NSManaged public var profileimage: Data?
    @NSManaged public var properties: NSSet?

}

// MARK: Generated accessors for properties
extension User {

    @objc(addPropertiesObject:)
    @NSManaged public func addToProperties(_ value: Property)

    @objc(removePropertiesObject:)
    @NSManaged public func removeFromProperties(_ value: Property)

    @objc(addProperties:)
    @NSManaged public func addToProperties(_ values: NSSet)

    @objc(removeProperties:)
    @NSManaged public func removeFromProperties(_ values: NSSet)

}

extension User : Identifiable {

}
