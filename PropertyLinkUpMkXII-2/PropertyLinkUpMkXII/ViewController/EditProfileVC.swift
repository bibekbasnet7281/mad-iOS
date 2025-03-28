//
//  EditProfileVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit
import CoreData

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var loggedInUser: User?
    
    @IBOutlet weak var imgProfileView: UIImageView!
    @IBOutlet weak var txtGenderField: UITextField!
    @IBOutlet var txtNameField: [UITextField]!
    @IBOutlet var txtEmailField: [UITextField]!
    @IBOutlet weak var txtPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Logged-in user: \(String(describing: loggedInUser))")
        populateUserData()
    }

    // Populate UI fields with the user data
    func populateUserData() {
        guard let user = loggedInUser else {
            print("No logged-in user found.")
            return
        }

        // Populate text fields
        for txtName in txtNameField {
            txtName.text = user.name
        }
        for txtEmail in txtEmailField {
            txtEmail.text = user.email
        }
        txtGenderField.text = user.gender
        txtPasswordField.text = user.password

        // Load profile image
        if let imageData = user.profileimage, let image = UIImage(data: imageData) {
            imgProfileView.image = image
        } else {
            imgProfileView.image = UIImage(named: "placeholder") // Default placeholder image
        }
    }

    // Save profile data (name, email, gender, password) to Core Data
    @IBAction func Tap_SaveProfile(_ sender: Any) {
        guard let user = loggedInUser else {
            print("No logged-in user found.")
            return
        }

        // Update user attributes
        user.name = txtNameField.first?.text
        user.email = txtEmailField.first?.text
        user.gender = txtGenderField.text
        user.password = txtPasswordField.text

        // Update profile image if it was changed
        if let imageData = imgProfileView.image?.jpegData(compressionQuality: 0.8) {
            user.profileimage = imageData
        }

        // Save context to persist changes
        do {
            try PersistenceController.shared.context.save()
            print("User data saved successfully.")
            showSuccessAlert()
        } catch let error as NSError {
            print("Failed to save user data: \(error), \(error.userInfo)")
            showErrorAlert(message: "Failed to save user data.")
        }
    }

    // Success alert after saving profile changes
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Your profile has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    // Error alert when something goes wrong
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    // Fetch the logged-in user from Core Data
    func fetchUserFromDatabase(email: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try PersistenceController.shared.context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }

    // Select and update profile image
    @IBAction func Tap_addImageProfile(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }

    // Image picker callback to update profile image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imgProfileView.image = selectedImage

            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                loggedInUser?.profileimage = imageData
                do {
                    try PersistenceController.shared.context.save()
                    print("Profile image updated successfully.")
                } catch let error as NSError {
                    print("Failed to save profile image: \(error), \(error.userInfo)")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // Handle account deletion
    @IBAction func Tap_DeleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.deleteUserAccount()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }

    // Delete the user account and redirect to login screen
    func deleteUserAccount() {
        guard let user = loggedInUser else {
            print("No logged-in user found.")
            return
        }

        // Delete user from Core Data
        PersistenceController.shared.context.delete(user)

        // Save context after deletion
        do {
            try PersistenceController.shared.context.save()
            print("User account deleted successfully.")
            navigateToLoginScreen()
        } catch let error as NSError {
            print("Failed to delete user account: \(error), \(error.userInfo)")
        }
    }

    // Navigate to the login screen
    func navigateToLoginScreen() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}

