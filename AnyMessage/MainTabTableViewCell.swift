//
//  MainTabTableViewCell.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 11.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit

class MainTabTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
