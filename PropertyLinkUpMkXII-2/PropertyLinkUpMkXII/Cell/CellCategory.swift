//
//  CellCategory.swift
//  PropertyLinkUpMkXII
//
//  Created by NAAMI COLLEGE on 25/03/2025.
//

import UIKit

class CellCategory: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPropertyTitle: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
