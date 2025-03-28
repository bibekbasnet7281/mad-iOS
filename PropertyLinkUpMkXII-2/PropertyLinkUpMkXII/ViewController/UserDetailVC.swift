//
//  UserDetailVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 27/03/2025.
//
import UIKit

class UserDetailVC: UIViewController {
    
    var user: User? 
    
 
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserGender: UILabel!
    @IBOutlet weak var lblUserrole: UILabel!
    @IBOutlet weak var ImgProfileView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton! // IBOutlet for the button
    

    @IBAction func Tap_UserProperty(_ sender: Any) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if let user = user {
            lblUsername.text = user.name ?? "No Username"
            lblUserEmail.text = user.email ?? "No Email"
            lblUserGender.text = user.gender ?? "No Gender"
            lblUserrole.text = user.userrole ?? "No Role"

           
            if let imageData = user.profileimage, let image = UIImage(data: imageData) {
                ImgProfileView.image = image
            } else {
                ImgProfileView.image = UIImage(named: "placeholder")
            }
            
  
            if user.userrole == "buyer" {
                editProfileButton.isEnabled = false
                editProfileButton.alpha = 0.5
            } else {
                editProfileButton.isEnabled = true
                editProfileButton.alpha = 1.0
            }
        }
    }

  
    @IBAction func EditUserProfile(_ sender: Any) {
       
        if user != nil {
            if let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC {
             
                
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
        } else {
           
            print("No user data available.")
        }
    }
}
