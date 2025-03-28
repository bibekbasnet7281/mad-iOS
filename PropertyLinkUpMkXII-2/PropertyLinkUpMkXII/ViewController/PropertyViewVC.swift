//
//  PropertyViewVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//
import UIKit

class PropertyViewVC: UIViewController {

    var property: Property?
    var loggedInUser: User?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnEditProperty: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnEditProperty.isHidden = true

   
        if let property = property {
            lblTitle.text = property.title
            lblPrice.text = "$\(property.price)"
            lblLocation.text = property.location
            lblDetail.text = property.detail ?? "No details available"
            
            if let imageData = property.image, let image = UIImage(data: imageData) {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "placeholder")
            }
        }

      
        debugUserAndProperty()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkEditButtonVisibility()
    }

    private func checkEditButtonVisibility() {
        guard let user = loggedInUser else {
            print("Error: loggedInUser is nil")
            return
        }

        guard let propertyOwner = property?.user else {
            print("Error: property.user is nil")
            return
        }

        print("Logged-in user ID: \(user.userId), Role: \(user.userrole ?? "Not available")")
        print("Property owner ID: \(propertyOwner.userId), Role: \(propertyOwner.userrole ?? "Not available")")

        if user.userrole == "landlord" && user.userId == propertyOwner.userId {
            print("Edit button visible for property owner")
            btnEditProperty.isHidden = false
        } else {
            print("Edit button hidden")
            btnEditProperty.isHidden = true
        }
    }

    private func debugUserAndProperty() {
        print("Property Info: \(String(describing: property))")
        print("Logged-in User Info: \(String(describing: loggedInUser))")
        if let user = loggedInUser {
            print("Logged-in User ID: \(user.userId), Role: \(user.userrole ?? "Not available")")
        }
        if let propertyOwner = property?.user {
            print("Property Owner ID: \(propertyOwner.userId), Role: \(propertyOwner.userrole ?? "Not available")")
        }
    }

    @IBAction func Tap_ContactLandlord(_ sender: Any) {
        print("Contacting landlord...")
 
    }

    @IBAction func Tap_EditProperty(_ sender: Any) {
        print("Editing property...")

        if let editVC = storyboard?.instantiateViewController(withIdentifier: "EditPropertyVC") as? EditPropertyVC {
            editVC.property = property
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
}
