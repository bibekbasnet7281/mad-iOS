//
//  UserListViewCellCategory.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 27/03/2025.
//

import UIKit

class UserListViewCellCategory: UITableViewCell {
    
        @IBOutlet weak var lbluseremail: UILabel!
        @IBOutlet weak var lblUserName: UILabel!
        @IBOutlet weak var lblUserrole: UILabel!
        @IBOutlet weak var imgUserProfile: UIImageView!
    
        override func awakeFromNib() {
            super.awakeFromNib()
       
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

       
        }

    }
