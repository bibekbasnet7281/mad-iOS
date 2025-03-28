//
//  UserViewListVC.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 26/03/2025.

import CoreData 


import UIKit



class UserViewListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
   
          let nib = UINib(nibName: "UserListViewCellCategory", bundle: nil)
          tableView.register(nib, forCellReuseIdentifier: "UserListViewCellCategory")

        tableView.dataSource = self
        tableView.delegate = self

      
        tableView.register(UINib(nibName: "UserListViewCellCategory", bundle: nil), forCellReuseIdentifier: "UserListViewCellCategory")

        fetchUsers()
    }


    func fetchUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try PersistenceController.shared.context.fetch(fetchRequest)
            print("Fetched \(users.count) users")
            tableView.reloadData()
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }

 
    func navigateToUserDetail(user: User) {
        if let userDetailVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC {
            userDetailVC.user = user
            navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
}

extension UserViewListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListViewCellCategory", for: indexPath) as? UserListViewCellCategory else {
            fatalError("Could not dequeue UserListViewCellCategory")
        }

        let user = users[indexPath.row]
        cell.lblUserName.text = user.name ?? "Unknown"
        cell.lbluseremail.text = user.email ?? "Unknown"
        cell.lblUserrole.text = user.userrole ?? "Unknown"

        if let imageData = user.profileimage, let image = UIImage(data: imageData) {
            cell.imgUserProfile.image = image
        } else {
            cell.imgUserProfile.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToUserDetail(user: users[indexPath.row])
    }
}
