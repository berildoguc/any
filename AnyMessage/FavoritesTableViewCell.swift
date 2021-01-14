//
//  FavoritesTableViewCell.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 6.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTel: UILabel!
    @IBOutlet weak var bubble: UIImageView!
    @IBOutlet weak var bubbleFirstLetter: UILabel!
    @IBOutlet weak var dial: UIView!
    @IBOutlet weak var imgDial: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bubble.layer.masksToBounds = false
        bubble.layer.cornerRadius = bubble.frame.height/2
        bubble.clipsToBounds = true    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
