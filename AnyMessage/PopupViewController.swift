//
//  PopupViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 21.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    

    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
            
        }
    }
    
    var contact: ContactItem? = ContactItem(id: "0", firstName: "", middleName: "", familyName: "", phoneNumber: "", isFavorite: "false", img: nil)
    var highlightedColon = ""
    var lastTab = ""
    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
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
extension PopupViewController: MIBlurPopupDelegate {
    
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
        
       guard let popupContentViewController = segue.destination as? PopupContentViewController else { return }
       popupContentViewController.contact = contact
       popupContentViewController.highlightedColon = highlightedColon
       popupContentViewController.lastTab = lastTab

        
    }
    @objc func dismissDialog(_ notification: Notification) {

        dismiss(animated: true)

    }
    
    
}
