//
//  PopupNote.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 13.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class PopupNote: UIViewController {
    
    
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
    var noteID: Int? = nil
    var content = ""
    var date = Date()
    var fromMainPage: Bool = false

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
extension PopupNote: MIBlurPopupDelegate {
    
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
        
        guard let popupContentViewController = segue.destination as? PopupNoteContent else { return }
        popupContentViewController.contactID = contactID
        if(content != ""){
            popupContentViewController.noteID = self.noteID
            popupContentViewController.content = self.content
            popupContentViewController.date = self.date
            popupContentViewController.fromMainPage = fromMainPage
        }
        
    }
    @objc func dismissDialog(_ notification: Notification) {
        
        dismiss(animated: true)
        
    }
    
    
}
