//
//  LandlordProfileVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//
import UIKit

class LandlordProfileVC: UIViewController {
    
    var loggedInUser: User?


    @IBOutlet weak var lblNameField: UILabel!
    @IBOutlet weak var lblPasswordField: UILabel!
    @IBOutlet weak var lblEmailField: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var imgProfileView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        if let user = loggedInUser {
            lblNameField.text = user.name ?? "No Name"
            lblEmailField.text = user.email ?? "No Email"
            lblGender.text = user.gender ?? "No Gender"
            lblPasswordField.text = user.password ?? "No Password"

            // Load profile image if available, otherwise show placeholder image
            if let imageData = user.profileimage, let image = UIImage(data: imageData) {
                imgProfileView.image = image
            } else {
                imgProfileView.image = UIImage(named: "placeholder")
            }
        }
    }

    @IBAction func Tap_PropertyList(_ sender: Any) {
        
 
    
            if let landlordPropertyVC = storyboard?.instantiateViewController(withIdentifier: "LandlordPropertyViewList") as? LandlordPropertyViewList {
                
           
                
                
                navigationController?.pushViewController(landlordPropertyVC, animated: true)
            } else {
                print("Error: Could not instantiate LandlordPropertyViewList.")
            }
        

    }

    @IBAction func Tap_EditProfile(_ sender: Any) {
      
        if let user = loggedInUser {
            if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
              
                editProfileVC.loggedInUser = user
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
        } else {
      
            print("No logged in user found.")
        }
    }
}
