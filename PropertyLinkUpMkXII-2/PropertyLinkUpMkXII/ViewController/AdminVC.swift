//
//  AdminVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit

class AdminVC: UIViewController {
    
    var loggedInUser: User?
    
    @IBOutlet weak var imgAdminProfile: UIImageView!
    @IBOutlet weak var AdminName: UILabel!
    @IBOutlet weak var lblAdminEmailField: UILabel!
    @IBOutlet weak var lblAdminGenderLabel: UILabel!
    @IBOutlet weak var lblAdminPasswordFiled: UILabel!
    

    @IBAction func Tap_ViewUserList(_ sender: Any) {
        
        if let userViewListVC = storyboard!.instantiateViewController(withIdentifier: "UserViewListVC") as? UserViewListVC {
            print("UserViewListVC initialized successfully")
            navigationController?.pushViewController(userViewListVC, animated: true)
        } else {
            print("Failed to initialize UserViewListVC")
        }
    }
    @IBAction func Tap_Home(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            // Pass the logged-in user details to HomeVC
                    homeVC.loggedInUser = loggedInUser
            navigationController?.pushViewController(homeVC, animated: true)
        }
        
    }
    
 
    @IBAction func Tap_ViewProperytList(_ sender: Any) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let propertyListVC = storyboard.instantiateViewController(withIdentifier: "PropertyListView") as? PropertyListView {
            navigationController?.pushViewController(propertyListVC, animated: true)
        }
    }

    @IBAction func Tap_EditAdminProfile(_ sender: Any) {
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
        if let user = loggedInUser {
         
            AdminName.text = user.name
            lblAdminEmailField.text = user.email
            lblAdminGenderLabel.text = user.gender
            lblAdminPasswordFiled.text = user.password
            
           
            if let imageData = user.profileimage, let image = UIImage(data: imageData) {
                imgAdminProfile.image = image
            }
        }
    }
}
