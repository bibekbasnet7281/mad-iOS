//
//  AdminUserManager.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 27/03/2025.
//

import Foundation
import Foundation
import CoreData
import UIKit

class UserManager {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static func setupDefaultAdminAccount() {
        let userManager = UserManager()
        
        // Fetch all users where userrole == "admin"
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userrole == %@", "admin")
        
        do {
            let results = try userManager.context.fetch(fetchRequest)
            
            if results.isEmpty {
              
                
                let defaultAdmin = User(context: userManager.context)
                defaultAdmin.userId = UUID()
                defaultAdmin.name = "Admin"
                defaultAdmin.email = "admin@gmail.com"
                defaultAdmin.password = "admin123"
                defaultAdmin.userrole = "admin"
                defaultAdmin.gender = "Other"
                defaultAdmin.profileimage = nil
                
         
                try userManager.context.save()
                print("Default admin account created.")
            } else {
                print("Admin account already exists.")
            }
        } catch {
            print("Error fetching admin user: \(error.localizedDescription)")
        }
    }
}
