//
//  PropertyListView.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 27/03/2025.
//

import UIKit
import CoreData

class PropertyListView: UIViewController {
    var loggedInUser: User?
    var properties: [Property] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

      
        tableView.dataSource = self
        tableView.delegate = self

        fetchProperties()

     
    }

    @IBAction func Tap_ProfileView(_ sender: Any) {
        guard let userRole = loggedInUser?.userrole else {
            print("User role is not set")
            return
        }

        if userRole == "admin" {
            if let adminVC = storyboard?.instantiateViewController(withIdentifier: "AdminVC") as? AdminVC {
                adminVC.loggedInUser = loggedInUser
                navigationController?.pushViewController(adminVC, animated: true)
            }
        } else if userRole == "landlord" {
            if let landlordProfileVC = storyboard?.instantiateViewController(withIdentifier: "LandlordProfileVC") as? LandlordProfileVC {
                landlordProfileVC.loggedInUser = loggedInUser
                navigationController?.pushViewController(landlordProfileVC, animated: true)
            }
        } else {
            if let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                profileVC.loggedInUser = loggedInUser
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }

    @IBAction func Tap_addProperty(_ sender: Any) {
        if let userRole = loggedInUser?.userrole, userRole == "landlord" {
            if let addPropertyVC = storyboard?.instantiateViewController(withIdentifier: "AddPropertyVC") as? AddPropertyVC {
                addPropertyVC.loggedInUser = loggedInUser
                navigationController?.pushViewController(addPropertyVC, animated: true)
            }
        } else {
            showUpgradeAlert()
        }
    }

    func fetchProperties() {
        let fetchRequest: NSFetchRequest<Property> = Property.fetchRequest()

        do {
            properties = try PersistenceController.shared.context.fetch(fetchRequest)
            print("Fetched \(properties.count) properties from database")
            tableView.reloadData()
        } catch {
            print("Error fetching properties: \(error.localizedDescription)")
        }
    }

    func showUpgradeAlert() {
        let alert = UIAlertController(title: "Upgrade Required", message: "You need to upgrade your account to a landlord to add properties. Please contact support or visit your profile to upgrade.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}

extension PropertyListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellCategory = tableView.dequeueReusableCell(withIdentifier: "CellCategory", for: indexPath) as! CellCategory

        let property = properties[indexPath.row]

        cell.lblPropertyTitle.text = property.title
        cell.lblPrice.text = "$\(property.price)"
        cell.lblLocation.text = property.location

        if let imageData = property.image, let image = UIImage(data: imageData) {
            if let imageView = cell.imageView {
                imageView.image = image
            }
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let property = properties[indexPath.row]

        if let propertyViewVC = storyboard?.instantiateViewController(withIdentifier: "PropertyViewVC") as? PropertyViewVC {
            propertyViewVC.property = property
            propertyViewVC.loggedInUser = loggedInUser
            navigationController?.pushViewController(propertyViewVC, animated: true)
        }
    }
}
