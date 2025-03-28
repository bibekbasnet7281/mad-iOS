//
//  PersistentStorage.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }

    init() {
        container = NSPersistentContainer(name: "PropertyLinkUpMkXII")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                          fatalError("Unresolved error \(error), \(error.userInfo)")
                      } else if let databaseURL = description.url {
                          print("Database Path: \(databaseURL.path)")
                      } else {
                          print("Database path not found.")
                      }
                  }
              }
    

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
