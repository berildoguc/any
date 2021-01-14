//
//  ContactCollectionCell.swift
//  AnyMessage
//
//  Created by Enes Eray on 7.01.2021.
//  Copyright © 2021 HH&HS Apps. All rights reserved.
//

import UIKit

@IBDesignable class ContactCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        self.image.layer.masksToBounds = false
        self.image.layer.cornerRadius = self.image.frame.width / 2
        self.image.clipsToBounds = true
      }
}
