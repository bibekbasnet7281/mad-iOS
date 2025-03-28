//
//  Property+CoreDataProperties.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//
//

import Foundation
import CoreData


extension Property {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Property> {
        return NSFetchRequest<Property>(entityName: "Property")
    }

    @NSManaged public var title: String?
    @NSManaged public var detail: String?
    @NSManaged public var price: Int32
    @NSManaged public var location: String?
    @NSManaged public var propertyId: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var user: User?

}

extension Property : Identifiable {

}
