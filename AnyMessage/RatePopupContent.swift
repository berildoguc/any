//
//  RatePopupContent.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 4.01.2020.
//  Copyright © 2020 HH&HS Apps. All rights reserved.
//

import UIKit

class RatePopupContent: UIViewController {

    @IBOutlet weak var txtRate: UILabel!
    @IBOutlet weak var txtBtnYes: UIButton!
    @IBOutlet weak var txtBtnNo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtRate.text = NSLocalizedString("rate", comment: "")
        txtBtnYes.setTitle(NSLocalizedString("yes", comment: ""), for: .normal)
        txtBtnNo.setTitle(NSLocalizedString("no", comment: ""), for: .normal)
        
    }
    
    @IBAction func btnYes(_ sender: Any) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1462188725"),
                                UIApplication.shared.canOpenURL(url)
                            {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)

    }
    
    @IBAction func btnNo(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)

    }
    

}
