//
//  SplashScreen.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 15.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import Contacts
class SplashScreen: UIViewController {
    var listContacts = [ContactItem]()
    var favoriteList = [ContactItem]()
    let defaults = UserDefaults.standard
    var firstSession = true
    var backFromSettings = false
    var gotEmailsOnce = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadDataContacts(_:)), name: Notification.Name(rawValue: "loadDataContacts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name:
               UIApplication.willEnterForegroundNotification, object: nil)
        if(defaults.object(forKey: "firstSession") != nil){
            firstSession  = defaults.bool(forKey: "firstSession")
        }
       gotEmailsOnce = defaults.bool(forKey: "gotEmailFromContactsOnce")
        
        if(firstSession){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "IntroVC")
            controller.modalPresentationStyle = .fullScreen

            self.present(controller, animated: true, completion: nil)
       
            
            return
        }
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
            
        }
        fetchContacts()
    }
    
    @objc func loadDataContacts(_ notification: Notification) {
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
            
        }
        fetchContacts()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destVC : MainViewController = segue.destination as! MainViewController
       destVC.listContacts = listContacts

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
           
            
            if granted {
                let keys = [CNContactIdentifierKey ,CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                DispatchQueue.main.async {
                    do {
                        
                        
                        try store.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
                            
                            if(contact.phoneNumbers.first?.value != nil){

                                var isFavorite = "false"
                                for contactFav in self.favoriteList {
             
                                    if(contactFav.id == contact.identifier){
                                        isFavorite = "true"
                                        if(contact.imageDataAvailable){
                                            contactFav.firstName = contact.givenName
                                            contactFav.middleName = contact.middleName
                                            contactFav.familyName = contact.familyName
                                            contactFav.phoneNumber = (contact.phoneNumbers.first?.value.stringValue)!
                                            contactFav.img = contact.thumbnailImageData!
                                        }
                                    }
                                    
                                }
                                
                                var contactItem: ContactItem
                                if(contact.imageDataAvailable){
                                      if(contact.givenName + contact.middleName + contact.familyName == ""){
                                        
                                        contactItem = ContactItem(id: contact.identifier, firstName: "#", middleName: contact.middleName, familyName: contact.familyName, phoneNumber: (contact.phoneNumbers.first?.value.stringValue)!, isFavorite: isFavorite, img: contact.thumbnailImageData!)
                                      }else{
                                         contactItem = ContactItem(id: contact.identifier, firstName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, phoneNumber: (contact.phoneNumbers.first?.value.stringValue)!, isFavorite: isFavorite, img: contact.thumbnailImageData!)
                                    }
                                 
                                }else{
                            
                                    if(contact.givenName + contact.middleName + contact.familyName == ""){
                                        
                                        contactItem = ContactItem(id: contact.identifier, firstName: "#", middleName: contact.middleName, familyName: contact.familyName, phoneNumber: (contact.phoneNumbers.first?.value.stringValue)!, isFavorite: isFavorite, img: nil)
                                        
                                    }else{
                                        contactItem = ContactItem(id: contact.identifier, firstName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, phoneNumber: (contact.phoneNumbers.first?.value.stringValue)!, isFavorite: isFavorite, img: nil)
                                        
                                    }
                                }
                                
                                if(!self.gotEmailsOnce){
                                    let userNames: UsernamesItem? = DbUtil.sharedInstance.getUserNames(contactId: contact.identifier)
                                            
                                           if(userNames != nil){
                                                 DbUtil.sharedInstance.updateUserNames(contactId: userNames!.id, fbUsername: userNames?.fbUsername, twitterUserName: userNames?.twitterUsername, instagramUserName: userNames?.instagramUsername, gmailUserName: (contact.emailAddresses.first?.value.description), visibilityFbUsername: userNames!.visibilityFbUsername, visibilityTwitterUsername:userNames!.visibilityTwitterUsername, visibilityInstagramUsername: userNames!.visibilityInstagramUsername, visibilityGmailUsername: userNames!.visibilityGmailUsername, visibilityNotes: userNames!.visibilityNotes, customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab2Name, customTab3Name: userNames?.customTab3Name, customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab2Url, customTab3Url: userNames?.customTab3Url)
                                           
                                             }else{
                                            DbUtil.sharedInstance.addUserNames(contactId: contact.identifier, fbUsername: "", twitterUserName: "", instagramUserName: "", gmailUserName: (contact.emailAddresses.first?.value.description), visibilityFbUsername: "1", visibilityTwitterUsername: "1", visibilityInstagramUsername: "1", visibilityGmailUsername: "1", visibilityNotes: "1", customTab1Name: "", customTab2Name: "", customTab3Name: "", customTab1Url: "", customTab2Url: "", customTab3Url: "")
                                            }
                                  }
                                
                                
                                self.listContacts.append(contactItem)

                            }
                        })
                        
                    
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.favoriteList)
                        self.defaults.set(encodedData, forKey: "favoriteList")
                        if(!self.gotEmailsOnce){
                            self.defaults.set(true, forKey: "gotEmailFromContactsOnce")
                        }
                        self.defaults.synchronize()
                        
                        
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "splashScreenSegue", sender: self)

                        
                    } catch let err {
                        print("Failed to enumerate contacts:", err)
                    }

                    return

                }
                
                
            } else {
                
        
                
                let alert = UIAlertController(title: NSLocalizedString("permission_error_title", comment: ""), message: NSLocalizedString("permission_error_desc", comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("exit", comment: ""), style: .default, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("allow", comment: ""), style: .default, handler: { action in
                    self.backFromSettings = true
                                  UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                 }))

                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.present(alert, animated: true, completion: nil)

                }
                
                return

            }
       
        }
    }
    @objc func onResume() {
        if(backFromSettings){
            
            backFromSettings = false
            self.fetchContacts()
        
        }
    }

}
