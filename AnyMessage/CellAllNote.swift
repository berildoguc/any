//
//  CellAllNote.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 20.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class CellAllNote: UITableViewCell {
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var bubbleFirstLetter: UILabel!
    @IBOutlet weak var bubble: UIImageView!
    
    
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
