//
//  LoginVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//
import UIKit
import CoreData

class LoginVC: UIViewController {
    
    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var lblEmailField: UITextField!
    @IBOutlet weak var lblPasswordField: UITextField!
    @IBOutlet weak var lblError: UILabel!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
           lblError.isHidden = true
        
    
// the design part of the login screen
        lblAppTitle.textColor = UIColor(red: 0/50, green: 0/102, blue: 255/255, alpha: 1) // Deep blue
        lblAppTitle.font = UIFont.boldSystemFont(ofSize: 36)  // Larger font for better visibility
        
       // emails and password
        setupTextField(lblEmailField)
        setupTextField(lblPasswordField)
        
      //lbl error that shows message
        lblError.textColor = UIColor.red
        lblError.isHidden = true
        
      // calling the image for the Ui background
        addBackgroundImage()
    }

    // This function  adds image to the background
    func addBackgroundImage() {
        let imageView = UIImageView(frame: CGRect(x: 30, y: 35, width: view.bounds.width * 0.9, height: view.bounds.height * 0.5)) // Resize to 80% of the original size
        
        if let image = UIImage(named: "propertyImage1") {
            imageView.image = image
        } else {
            print("Image not found!")
        }

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.view.insertSubview(imageView, at: 0)
        lblAppTitle.layer.zPosition = 1
    }

    // sets up the textfield
    func setupTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.font = UIFont.systemFont(ofSize: 16)
    }

    @IBAction func tapLogin(_ sender: Any) {
        guard let email = lblEmailField.text, !email.isEmpty,
              let password = lblPasswordField.text, !password.isEmpty else {
            showError("Please enter both email and password.")
            return
        }
        
        // user data is being fetch from the database core data
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try context.fetch(request)
            
            if let user = users.first {
                print("Login successful: \(user.name ?? "Unknown")")
                
             // hiding the error lbl
                hideError()
                
                // user is logged in based on user role
                if user.userrole == "admin" {
                    navigateToAdminDashboard(user: user)
                } else {
                    navigateToHome(user: user)
                }
            } else {
                showError("Invalid email or password.")
            }
        } catch {
            showError("Error fetching user: \(error.localizedDescription)")
        }
    }

    // function to show error message
    private func showError(_ message: String) {
        lblError.text = message
        lblError.isHidden = false
    }

   // Hiding the error message
    private func hideError() {
        lblError.isHidden = true
    }


    @IBAction func tapSignUp(_ sender: Any) {
        //  move to signup screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    private func navigateToHome(user: User) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            homeVC.loggedInUser = user
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    private func navigateToAdminDashboard(user: User) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminVC") as? AdminVC {
            adminVC.loggedInUser = user
            navigationController?.pushViewController(adminVC, animated: true)
        }
    }
}
