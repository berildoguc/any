//
//  Intro1.swift
//
//  Created by Haydar Kardeşler on 02/01/2019.
//  Copyright © 2019 Nuri Yigit. All rights reserved.
//

import UIKit

class Intro1: UIViewController {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var tx: UILabel!
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if(page == 0){
            tx.text = NSLocalizedString("intro1_string", comment: "")
            img.image = UIImage(named: "intro")
        }else{
            tx.text = NSLocalizedString("intro2_string", comment: "")
            img.image = UIImage(named: "intro2")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

