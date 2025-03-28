//
//  PropertyListCellCategory.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 26/03/2025.
//

import UIKit

class PropertyListCellCategory: UITableViewCell {

    @IBOutlet weak var lblLocationField: UILabel!
    @IBOutlet weak var lblTitleField: UILabel!
    @IBOutlet weak var lblPriceField: UILabel!
    @IBOutlet weak var PropertyImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
