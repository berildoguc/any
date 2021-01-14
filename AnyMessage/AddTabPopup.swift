//
//  AddTabPopup.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 03/12/2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class AddTabPopup: UIViewController {
    

    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
            
        }
    }
    
 
    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    var contactID = ""
    var tabNumber = 0

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
                NotificationCenter.default.addObserver(self, selector: #selector(dismissDialog(_:)), name: Notification.Name(rawValue: "dismissDialog"), object: nil)
        
      
    }
    


}

// MARK: - MIBlurPopupDelegate
extension AddTabPopup: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        return UIBlurEffect.Style.dark
    }
    
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
  
           guard let popupContentViewController = segue.destination as? AddTabContent else { return }
           popupContentViewController.contactID = contactID
        popupContentViewController.tabNumber = tabNumber

     
    }
    @objc func dismissDialog(_ notification: Notification) {

        dismiss(animated: true)

    }
    
    
}
