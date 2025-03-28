//
//  LandlordPropertyViewList.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 26/03/2025.
//

import UIKit
import CoreData

class LandlordPropertyViewList: UIViewController {

    @IBOutlet weak var TableView: UITableView!

    var properties: [Property] = []
    var loggedInUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.dataSource = self
        TableView.delegate = self
        
  
        TableView.register(UINib(nibName: "PropertyListCellCategory", bundle: nil), forCellReuseIdentifier: "PropertyCell")
        

        fetchLandlordProperties()
    }


    func fetchLandlordProperties() {
        guard let user = loggedInUser, let userId = user.userId else {
            print("Error: Logged-in user or userId is nil")
            return
        }

        let fetchRequest: NSFetchRequest<Property> = Property.fetchRequest()
        

        fetchRequest.predicate = NSPredicate(format: "user.userId == %@", userId as CVarArg)

        do {
         
            properties = try PersistenceController.shared.context.fetch(fetchRequest)
            print("Fetched \(properties.count) properties for landlord: \(userId)")

            TableView.reloadData()
        } catch {
            print("Error fetching properties: \(error.localizedDescription)")
        }
    }
}

// MARK: - Table View Data Source and Delegate
extension LandlordPropertyViewList: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as! PropertyListCellCategory
        
        let property = properties[indexPath.row]

     
        cell.lblTitleField.text = property.title
        cell.lblPriceField.text = "$\(property.price)"
        cell.lblLocationField.text = property.location
        
       
        if let imageData = property.image, let image = UIImage(data: imageData) {
            cell.PropertyImageView.image = image
        } else {
            cell.PropertyImageView.image = UIImage(named: "placeholder")
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

   
        let selectedProperty = properties[indexPath.row]
        

        if let propertyViewVC = storyboard?.instantiateViewController(withIdentifier: "PropertyViewVC") as? PropertyViewVC {
            propertyViewVC.property = selectedProperty
            propertyViewVC.loggedInUser = loggedInUser 
            navigationController?.pushViewController(propertyViewVC, animated: true)
        }
    }
}
