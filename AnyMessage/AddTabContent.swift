//
//  AddTabContent.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 7.12.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class AddTabContent: UIViewController, UITextFieldDelegate  {

    
    @IBOutlet weak var fieldURL: UITextField!
    @IBOutlet weak var fieldTitle: UITextField!
    var userNames:UsernamesItem? = nil
    var contactID = ""
    var tabNumber = 0
    var isKeyboardShow = false;
    let colorBlue: UIColor = UIColor(red: 68.0/255.0, green: 138.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let colorRed: UIColor = UIColor(red: 254.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1.0)
    @IBOutlet weak var snackBarText: UILabel!
    @IBOutlet weak var snackBar: UIView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var txtUrl: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var btnSaveText: UIButton!
    @IBOutlet weak var btnDeleteText: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNames = DbUtil.sharedInstance.getUserNames(contactId: contactID)
        fieldTitle.placeholder = NSLocalizedString("example", comment: "")

               txtUrl.text = NSLocalizedString("url", comment: "")
               txtTitle.text = NSLocalizedString("title", comment: "")
        if(tabNumber != 0){
            headerView.backgroundColor = colorBlue
            btnSaveText.setTitleColor(colorBlue, for: .normal)
            btnDeleteText.setTitleColor(colorBlue, for: .normal)
            btnDeleteText.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)

            headerImage.image = UIImage(named: "edit_tab_icon")
            btnSaveText.setTitle(NSLocalizedString("done2", comment: ""), for: .normal)
            headerText.text = NSLocalizedString("edit_custom_tab", comment: "")
         

            if(tabNumber == 1){
                fieldURL.text = userNames?.customTab1Url
                fieldTitle.text = userNames?.customTab1Name

            }else if(tabNumber == 2){

                fieldURL.text = userNames?.customTab2Url
                fieldTitle.text = userNames?.customTab2Name

            }else{

                fieldURL.text = userNames?.customTab3Url
                fieldTitle.text = userNames?.customTab3Name

            }
        }else{
        btnDeleteText.setTitleColor(colorRed, for: .normal)
                     btnDeleteText.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
            btnSaveText.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
            headerText.text = NSLocalizedString("add_tab_text", comment: "")

        }
        scrollView.keyboardDismissMode = .interactive
        
NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)

        fieldURL.delegate = self
        fieldTitle.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let bottom = CGAffineTransform(translationX: 0, y: 60)
        self.snackBar.transform = bottom

    }

    @IBAction func btnSave(_ sender: Any) {
        
        if(fieldTitle.text != nil && fieldURL.text != nil){
                  if(fieldTitle.text!.count > 0 && !(fieldTitle.text?.elementsEqual(" "))! && (fieldURL.text?.contains("."))! && !(fieldTitle.text?.elementsEqual(" "))!){
                    
                    if(!(fieldURL.text?.contains("http"))!){
                       fieldURL.text = "http://" + fieldURL.text!
                      }
                    
                    if(canOpenURL(fieldURL.text!)){
                      if(!(fieldTitle.text?.elementsEqual(NSLocalizedString("facebook", comment: "")))! && !(fieldTitle.text?.elementsEqual(NSLocalizedString("twitter", comment: "")))! && !(fieldTitle.text?.elementsEqual(NSLocalizedString("instagram", comment: "")))! && !(fieldTitle.text?.elementsEqual(NSLocalizedString("notes", comment: "")))!){
                
                        
                        if(tabNumber == 0){
                          if(userNames != nil){
                              
                              if(userNames?.customTab1Name?.elementsEqual("") ?? true){
                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: fieldTitle.text, customTab2Name: userNames?.customTab2Name, customTab3Name: userNames?.customTab3Name, customTab1Url: fieldURL.text, customTab2Url: userNames?.customTab2Url, customTab3Url: userNames?.customTab3Url)
                              }else if(userNames?.customTab2Name?.elementsEqual("") ?? true){
                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: fieldTitle.text, customTab3Name: userNames?.customTab3Name, customTab1Url: userNames?.customTab1Url, customTab2Url: fieldURL.text, customTab3Url: userNames?.customTab3Url)
                              }else if(userNames?.customTab3Name?.elementsEqual("") ?? true){
                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab2Name, customTab3Name: fieldTitle.text, customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab2Url, customTab3Url: fieldURL.text)
                                  NotificationCenter.default.post(name: Notification.Name(rawValue: "viewAddTabHide"), object: nil)

                                  
                              }
                              
                          }else{
                            DbUtil.sharedInstance.addUserNames(contactId: contactID, fbUsername: "", twitterUserName: "", instagramUserName: "", gmailUserName: "", visibilityFbUsername: "1", visibilityTwitterUsername: "1", visibilityInstagramUsername: "1", visibilityGmailUsername: "1", visibilityNotes: "1", customTab1Name: fieldTitle.text, customTab2Name: "", customTab3Name: "", customTab1Url: fieldURL.text, customTab2Url: "", customTab3Url: "")
                          }
                        }else{
                                            if(tabNumber == 1){
                                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: fieldTitle.text, customTab2Name: userNames?.customTab2Name, customTab3Name: userNames?.customTab3Name, customTab1Url: fieldURL.text, customTab2Url: userNames?.customTab2Url, customTab3Url: userNames?.customTab3Url)
                                                }else if(tabNumber == 2){
                                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: fieldTitle.text, customTab3Name: userNames?.customTab3Name, customTab1Url: userNames?.customTab1Url, customTab2Url: fieldURL.text, customTab3Url: userNames?.customTab3Url)
                                                }else if(tabNumber == 3){
                                                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab2Name, customTab3Name: fieldTitle.text, customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab2Url, customTab3Url: fieldURL.text)
                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "viewAddTabHide"), object: nil)

                                                    
                                                }
                            
                        }
 
                            tabNumber = 0
                        let tabName:[String: String] = ["tabName": fieldTitle.text!]
                          NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshPage"), object: nil, userInfo: tabName)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)
                      }else{
                          view.endEditing(true)

                          snackBar(title: NSLocalizedString("unique_name_warning", comment: ""), long: true)

                      }
                    }else{
                            view.endEditing(true)

                        snackBar(title: NSLocalizedString("invalid_url", comment: ""), long: true)
                    }
              }else{
                      view.endEditing(true)

                  snackBar(title: NSLocalizedString("add_tab_alert", comment: ""), long: true)
              }
              }else{
                  view.endEditing(true)
                  snackBar(title: NSLocalizedString("add_tab_alert", comment: ""), long: true)

              }
        
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
        if(tabNumber != 0){
          
            if(tabNumber == 1){
                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab2Name, customTab2Name: userNames?.customTab3Name, customTab3Name: "", customTab1Url: userNames?.customTab2Url, customTab2Url: userNames?.customTab3Url, customTab3Url: "")
                                                        }else if(tabNumber == 2){
                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab3Name, customTab3Name: "", customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab3Url, customTab3Url: "")
                                                        }else if(tabNumber == 3){
                DbUtil.sharedInstance.updateUserNames(contactId: contactID, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: userNames?.gmailUsername, visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab2Name, customTab3Name: "", customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab2Url, customTab3Url: "")

                                                            
                 }

              tabNumber = 0

              NotificationCenter.default.post(name: Notification.Name(rawValue: "viewAddTabShow"), object: nil)
              NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshPage"), object: nil)
        }
                                          
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)
    }
    
    
    @objc func keyboardNotification(notification: NSNotification) {
          if let userInfo = notification.userInfo {
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
              let endFrameY = endFrame?.origin.y ?? 0
         
              if endFrameY >= UIScreen.main.bounds.size.height {
                  if(self.isKeyboardShow){

                      UIView.animate(withDuration: 0.2, animations: { () -> Void in
                          self.isKeyboardShow = false
                          self.contentView.frame.origin.y = 0
                          self.contentView.layoutIfNeeded()
                      })
                
                  }
              } else {

                  if(!isKeyboardShow){
                  

                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1 ) {
                          
                              UIView.animate(withDuration: 0.2, animations: { () -> Void in
                                                      self.isKeyboardShow = true
                                self.contentView.frame.origin.y -= keyboardSize.height/3.6

                                                      self.contentView.layoutIfNeeded()
                             

                                                  })
                          }
                    
                    }
                  }
              }
          
          }
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if(textField.tag == 0){
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                         nextField.becomeFirstResponder()
                      } else {
                         // Not found, so remove keyboard.
                         textField.resignFirstResponder()
                scrollView.setContentOffset(.zero, animated: true)

                      }
        }else{
           // btnAdd(self)
            textField.resignFirstResponder()
            scrollView.setContentOffset(.zero, animated: true)

        }
     
     
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func snackBar(title:String, long:Bool){
        snackBar.isHidden = false

        snackBarText.text = title
        var duration = 1.2
        if(long == true){
            duration = 2.0
        }
        let bottom = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {

            self.snackBar.transform = bottom
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+duration ) {
            let hide = CGAffineTransform(translationX: 0, y: 60)
            
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
                // Add the transformation in this block
                // self.container is your view that you want to animate
                self.snackBar.transform = hide
            }, completion: nil)
            self.snackBar.isHidden = true

        }
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
}
