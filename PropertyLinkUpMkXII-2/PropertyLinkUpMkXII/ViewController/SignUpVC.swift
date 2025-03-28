//
//  SignUpVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit
import CoreData

class SignUpVC: UIViewController {

    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var txtNameField: UITextField!
    @IBOutlet weak var txtEmailField: UITextField!
    @IBOutlet weak var txtPasswordField: UITextField!
    @IBOutlet weak var txtGenderField: UITextField!
    @IBOutlet weak var lblDisplayField: UILabel!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Tap_SignUpUser(_ sender: Any) {
        guard let name = txtNameField.text, !name.isEmpty,
              let email = txtEmailField.text, !email.isEmpty,
              let password = txtPasswordField.text, !password.isEmpty,
              let gender = txtGenderField.text, !gender.isEmpty else {
            lblDisplayField.text = "Please fill in all fields."
            return
        }
        

        if !isValidEmail(email) {
            lblDisplayField.text = "Please enter a valid email (e.g., user@example.com)."
            return
        }
        
  
        if password.count < 4 {
            lblDisplayField.text = "Password must be at least 4 characters long."
            return
        }
        
 
        let validGenders = ["male", "female", "other"]
        if !validGenders.contains(gender.lowercased()) {
            lblDisplayField.text = "Gender must be 'male', 'female', or 'other'."
            return
        }
        // Check if the email already exists in the database
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)

            do {
                let existingUsers = try context.fetch(fetchRequest)

                // If there are any users with the same email, show an error
                if !existingUsers.isEmpty {
                    lblDisplayField.text = "An account with this email already exists."
                    return
                }

                // Create the new user if the email is unique
                let newUser = User(context: context)
                newUser.userId = UUID()
                newUser.name = name
                newUser.email = email
                newUser.password = password
                newUser.gender = gender.lowercased()
                newUser.userrole = "normal"
                newUser.profileimage = nil

                try context.save()
                lblDisplayField.text = "User signed up successfully! Role: \(newUser.userrole ?? "normal")"
                print("User signed up: \(newUser.name ?? "Unknown")")

                navigationController?.popViewController(animated: true)

            } catch {
                lblDisplayField.text = "Error saving user: \(error.localizedDescription)"
                print("Error saving user: \(error.localizedDescription)")
            }
        }
    

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }


    func upgradeToLandlord(user: User) {
        user.userrole = "landlord"
        
        do {
   
            try context.save()
            print("User upgraded to Landlord: \(user.name ?? "Unknown")")
        } catch {
            print("Error upgrading user to Landlord: \(error.localizedDescription)")
        }
    }
}
