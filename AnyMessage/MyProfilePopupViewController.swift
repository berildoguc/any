//
//  MyProfilePopupViewController.swift
//
//  Created by Haydar Kardeşler on 26/12/2018.
//  Copyright © 2018 Nuri Yigit. All rights reserved.
//


import UIKit

class MyProfilePopupViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var popupContentContainerView: UIView!
    var lastTab = ""


    @IBOutlet var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
            
        }
    }
  
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
extension MyProfilePopupViewController: MIBlurPopupDelegate {
    
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
        guard let popupContentViewController = segue.destination as? MyProfilePopupContentViewController else { return }
        popupContentViewController.lastTab = lastTab
   
        
    }
    @objc func dismissDialog(_ notification: Notification) {
        
        dismiss(animated: true)
        
    }
}
