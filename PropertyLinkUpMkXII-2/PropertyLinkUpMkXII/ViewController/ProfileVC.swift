//
//  ProfileVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit

class ProfileVC: UIViewController {
    var loggedInUser: User?

   
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfileBuyer: UIImageView!
    @IBOutlet weak var lblUserGender: UILabel!
    @IBOutlet weak var lblUserPassword: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayUserProfile()
    }

    func displayUserProfile() {

        guard let user = loggedInUser else {
            print("User is not logged in")
            return
        }

        lblUserName.text = user.name
        lblUserGender.text = "Gender: \(user.gender ?? "Not available")"
        lblUserPassword.text = "Password: \(user.password ?? "Not available")"
        lblUserEmail.text = "Email: \(user.email ?? "Not available")"

      
        if let imageData = user.profileimage {
            imgProfileBuyer.image = UIImage(data: imageData)
        } else {
            imgProfileBuyer.image = UIImage(named: "placeholder")
        }

     
        if let userRole = user.userrole {
            if userRole == "landlord" {
            
                lblUserName.text = "\(user.name ?? "Landlord") (Landlord)"
            } else if userRole == "admin" {
           
                lblUserName.text = "\(user.name ?? "Admin") (Admin)"
            } else {
           
                lblUserName.text = "\(user.name ?? "Buyer") (Buyer)"
            }
        }
    }
    

    @IBAction func Tap_EditProfile(_ sender: Any) {
     
        if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
            editProfileVC.loggedInUser = loggedInUser
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    

    @IBAction func Tap_UpgradeProfile(_ sender: Any) {

        let alert = UIAlertController(title: "Upgrade Profile", message: "Are you sure you want to upgrade your profile to a landlord?", preferredStyle: .alert)
        
    
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
        
            if let user = self.loggedInUser {
                user.userrole = "landlord"
      
                PersistenceController.shared.save()
                
              
                let successAlert = UIAlertController(title: "Success", message: "Your profile has been upgraded to Landlord.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               
                    self.navigateToLandlordVC()
                }))
                self.present(successAlert, animated: true, completion: nil)
            }
        }
        
     
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
       
        self.present(alert, animated: true, completion: nil)
    }


    func navigateToLandlordVC() {
        if let landlordProfileVC = storyboard?.instantiateViewController(withIdentifier: "LandlordProfileVC") as? LandlordProfileVC {
          
            landlordProfileVC.loggedInUser = loggedInUser
            navigationController?.pushViewController(landlordProfileVC, animated: true)
        }
    }
}
