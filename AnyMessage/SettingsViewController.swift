//
//  SettingsViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 11.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//
/*public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 0.1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
 }
 */


import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    var mainTabList: [String] = ["contacts", "favorites", "notes"]
   var detailTabList: [String] = ["facebook", "instagram", "twitter", "gmail", "customtab1",  "customtab2", "customtab3", "notes"]
    let defaults = UserDefaults.standard
    @IBOutlet weak var desc_1: UILabel!
    @IBOutlet weak var desc_2: UILabel!
    @IBOutlet weak var desc_3: UILabel!
    @IBOutlet weak var desc_4: UILabel!
    @IBOutlet var btnWhatsapp: UIImageView!
    @IBOutlet var btnMessenger: UIImageView!
    @IBOutlet var btnViber: UIImageView!
    @IBOutlet var btnTelegram: UIImageView!
    @IBOutlet var btnSms: UIImageView!
    @IBOutlet weak var desc_choose_messaging: UILabel!
    
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    var reorder = false


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        self.title = NSLocalizedString("settings", comment: "")
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        desc_1.text = NSLocalizedString("settings_manage_main_page", comment: "")
        desc_2.text = NSLocalizedString("settings_drag_and_drop", comment: "")
        desc_3.text = NSLocalizedString("settings_rearrange_items", comment: "")
        desc_4.text = NSLocalizedString("settings_drag_and_drop", comment: "")
        desc_choose_messaging.text = NSLocalizedString("settings_choose_messenger", comment: "")

        if(defaults.object(forKey: "mainTabList") != nil){
            mainTabList  = defaults.array(forKey: "mainTabList") as! [String]
        
        }else{
            mainTabList[0] = "contacts"
            mainTabList[1] = "favorites"
            mainTabList[2] = "notes"
            defaults.set(mainTabList, forKey: "mainTabList")
            defaults.synchronize()
            
        }
        
        if(defaults.object(forKey: "detailTabList") != nil){
            detailTabList  = defaults.array(forKey: "detailTabList") as! [String]
            if(!defaults.bool(forKey: "addGmailOnce")){
                           detailTabList.insert("gmail", at: 3)
                            defaults.set(true, forKey: "addGmailOnce")
                            defaults.set(detailTabList, forKey: "detailTabList")
                            defaults.synchronize()
                       }
            
        }else{
            detailTabList[0] = "facebook"
                             detailTabList[1] = "instagram"
                             detailTabList[2] = "twitter"
                             detailTabList[3] = "gmail"
                             detailTabList[4] = "customtab1"
                             detailTabList[5] = "customtab2"
                             detailTabList[6] = "customtab3"
                             detailTabList[7] = "notes"
            defaults.set(true, forKey: "addGmailOnce")

            defaults.set(detailTabList, forKey: "detailTabList")
            defaults.synchronize()
            
        }
        

        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.isEditing = true

        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.isEditing = true
    
        hideWhatsapp = UserDefaults.standard.bool(forKey: "hideWhatsapp")
        hideMessenger = UserDefaults.standard.bool(forKey: "hideMessenger")
        hideViber = UserDefaults.standard.bool(forKey: "hideViber")
        hideTelegram = UserDefaults.standard.bool(forKey: "hideTelegram")
        hideSms = UserDefaults.standard.bool(forKey: "hideSms")

        if(hideWhatsapp){
           btnWhatsapp.image = UIImage(named: "whatsapp_pasif")
        }
        
        if(hideMessenger){
            btnMessenger.image = UIImage(named: "messenger_pasif")
        }
        
        if(hideViber){
            btnViber.image = UIImage(named: "viber_pasif")
        }
        
        if(hideTelegram){
            btnTelegram.image = UIImage(named: "telegram_pasif")
        }
        
        if(hideSms){
            btnSms.image = UIImage(named: "sms_pasif")
        }
        
        let tapGestureRecognizerWhatsapp = UITapGestureRecognizer(target: self, action: #selector(imageTappedWhatsapp(tapGestureRecognizer:)))
        btnWhatsapp.isUserInteractionEnabled = true
        btnWhatsapp.addGestureRecognizer(tapGestureRecognizerWhatsapp)
        
        let tapGestureRecognizerMessenger = UITapGestureRecognizer(target: self, action: #selector(imageTappedMessenger(tapGestureRecognizer:)))

        btnMessenger.isUserInteractionEnabled = true
        btnMessenger.addGestureRecognizer(tapGestureRecognizerMessenger)
        
        let tapGestureRecognizerViber = UITapGestureRecognizer(target: self, action: #selector(imageTappedViber(tapGestureRecognizer:)))

        btnViber.isUserInteractionEnabled = true
        btnViber.addGestureRecognizer(tapGestureRecognizerViber)
        
        let tapGestureRecognizerTelegram = UITapGestureRecognizer(target: self, action: #selector(imageTappedTelegram(tapGestureRecognizer:)))

        btnTelegram.isUserInteractionEnabled = true
        btnTelegram.addGestureRecognizer(tapGestureRecognizerTelegram)
        
        let tapGestureRecognizerSms = UITapGestureRecognizer(target: self, action: #selector(imageTappedSms(tapGestureRecognizer:)))
        btnSms.isUserInteractionEnabled = true
        btnSms.addGestureRecognizer(tapGestureRecognizerSms)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
  
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        reorder = true
        if(mainTableView == tableView){
            let itemToMove = mainTabList[sourceIndexPath.row]
            mainTabList.remove(at: sourceIndexPath.row)
            mainTabList.insert(itemToMove, at: destinationIndexPath.row)
            defaults.set(mainTabList, forKey: "mainTabList")
            defaults.synchronize()
            self.mainTableView.reloadData()
            
        }else{
            let itemToMove = detailTabList[sourceIndexPath.row]
            detailTabList.remove(at: sourceIndexPath.row)
            detailTabList.insert(itemToMove, at: destinationIndexPath.row)
            defaults.set(detailTabList, forKey: "detailTabList")
            defaults.synchronize()
            self.detailTableView.reloadData()
            
        }
       

        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(mainTableView == tableView){

        return mainTabList.count
    }else{
    return detailTabList.count

      }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainTabTableViewCell
        if(mainTableView == tableView){
            cell = tableView.dequeueReusableCell(withIdentifier: "main_tab_cell") as! MainTabTableViewCell
            cell.lblTitle.text = detailTabList[indexPath.row]

        if(mainTabList[indexPath.row] == "contacts"){
            cell.lblTitle.text = NSLocalizedString("contacts", comment: "")
            cell.imgIcon.image = UIImage(named: "contacts")
        }else if(mainTabList[indexPath.row] == "favorites"){
            cell.lblTitle.text = NSLocalizedString("favorites", comment: "")
            cell.imgIcon.image = UIImage(named: "favorite")
        }else if(mainTabList[indexPath.row] == "notes"){
            cell.lblTitle.text = NSLocalizedString("notes", comment: "")
            cell.imgIcon.image = UIImage(named: "notes")
            }
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "detail_tab_cell") as! MainTabTableViewCell

            if(detailTabList[indexPath.row] == "facebook"){
                cell.lblTitle.text = NSLocalizedString("facebook", comment: "")
                cell.imgIcon.image = UIImage(named: "fb")
                
            }else if(detailTabList[indexPath.row] == "instagram"){
                cell.lblTitle.text = NSLocalizedString("instagram", comment: "")
                cell.imgIcon.image = UIImage(named: "instagram")
                
            }else if(detailTabList[indexPath.row] == "twitter"){
                cell.lblTitle.text = NSLocalizedString("twitter", comment: "")
                cell.imgIcon.image = UIImage(named: "twitter")
                
            }else if(detailTabList[indexPath.row] == "gmail"){
                cell.lblTitle.text = NSLocalizedString("gmail", comment: "")
                cell.imgIcon.image = UIImage(named: "gmail")
                
            }else if(detailTabList[indexPath.row] == "customtab1"){
                cell.lblTitle.text = NSLocalizedString("customtab1", comment: "")
                cell.imgIcon.image = UIImage(named: "custom_tab")
                
            }else if(detailTabList[indexPath.row] == "customtab2"){
                cell.lblTitle.text = NSLocalizedString("customtab2", comment: "")
                cell.imgIcon.image = UIImage(named: "custom_tab")
                
            }else if(detailTabList[indexPath.row] == "customtab3"){
                cell.lblTitle.text = NSLocalizedString("customtab3", comment: "")
                cell.imgIcon.image = UIImage(named: "custom_tab")
                
            }else if(detailTabList[indexPath.row] == "notes"){
                cell.lblTitle.text = NSLocalizedString("notes", comment: "")
                cell.imgIcon.image = UIImage(named: "notes")
                
            }
        }
        return cell
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if(reorder){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reOrderTab"), object: nil)
        }
        
    }
    
    @objc func imageTappedWhatsapp(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
    
        
        if #available(iOS 13.0, *) {
            if((tappedImage.image?.description.contains("whatsapp_pasif"))!){
                      
                    tappedImage.image = UIImage(named: "whatsapp")
                    UserDefaults.standard.set(false, forKey: "hideWhatsapp")

                  } else if((tappedImage.image?.description.contains("whatsapp"))!){
                      
                      tappedImage.image = UIImage(named: "whatsapp_pasif")
                      UserDefaults.standard.set(true, forKey: "hideWhatsapp")

                  }
            
        } else {
            if(tappedImage.image == UIImage(named:"whatsapp_pasif")){
                      
                    tappedImage.image = UIImage(named: "whatsapp")
                    UserDefaults.standard.set(false, forKey: "hideWhatsapp")

                  } else if(tappedImage.image == UIImage(named:"whatsapp")){
                      
                      tappedImage.image = UIImage(named: "whatsapp_pasif")
                      UserDefaults.standard.set(true, forKey: "hideWhatsapp")

                  }
            
        }
      
    }
    
    @objc func imageTappedMessenger(tapGestureRecognizer: UITapGestureRecognizer)
    {
  
        let tappedImage = tapGestureRecognizer.view as! UIImageView
    
             if #available(iOS 13.0, *) {
                 if((tappedImage.image?.description.contains("messenger_pasif"))!){
                           
                         tappedImage.image = UIImage(named: "messenger")
                         UserDefaults.standard.set(false, forKey: "hideMessenger")

                       } else if((tappedImage.image?.description.contains("messenger"))!){
                           
                           tappedImage.image = UIImage(named: "messenger_pasif")
                           UserDefaults.standard.set(true, forKey: "hideMessenger")

                       }
                 
             } else {
                 if(tappedImage.image == UIImage(named:"messenger_pasif")){
                           
                         tappedImage.image = UIImage(named: "messenger")
                         UserDefaults.standard.set(false, forKey: "hideMessenger")

                       } else if(tappedImage.image == UIImage(named:"messenger")){
                           
                           tappedImage.image = UIImage(named: "messenger_pasif")
                           UserDefaults.standard.set(true, forKey: "hideMessenger")

                       }
                 
             }
    }
    
    
    @objc func imageTappedViber(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
         let tappedImage = tapGestureRecognizer.view as! UIImageView
        
                 if #available(iOS 13.0, *) {
                     if((tappedImage.image?.description.contains("viber_pasif"))!){
                               
                             tappedImage.image = UIImage(named: "viber")
                             UserDefaults.standard.set(false, forKey: "hideViber")

                           } else if((tappedImage.image?.description.contains("viber"))!){
                               
                               tappedImage.image = UIImage(named: "viber_pasif")
                               UserDefaults.standard.set(true, forKey: "hideViber")

                           }
                     
                 } else {
                     if(tappedImage.image == UIImage(named:"viber_pasif")){
                               
                             tappedImage.image = UIImage(named: "viber")
                             UserDefaults.standard.set(false, forKey: "hideViber")

                           } else if(tappedImage.image == UIImage(named:"viber")){
                               
                               tappedImage.image = UIImage(named: "viber_pasif")
                               UserDefaults.standard.set(true, forKey: "hideViber")

                           }
                     
                 }
        
    }
    
    @objc func imageTappedTelegram(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
               
                        if #available(iOS 13.0, *) {
                            if((tappedImage.image?.description.contains("telegram_pasif"))!){
                                      
                                    tappedImage.image = UIImage(named: "telegram")
                                    UserDefaults.standard.set(false, forKey: "hideTelegram")

                                  } else if((tappedImage.image?.description.contains("telegram"))!){
                                      
                                      tappedImage.image = UIImage(named: "telegram_pasif")
                                      UserDefaults.standard.set(true, forKey: "hideTelegram")

                                  }
                            
                        } else {
                            if(tappedImage.image == UIImage(named:"telegram_pasif")){
                                      
                                    tappedImage.image = UIImage(named: "telegram")
                                    UserDefaults.standard.set(false, forKey: "hideTelegram")

                                  } else if(tappedImage.image == UIImage(named:"telegram")){
                                      
                                      tappedImage.image = UIImage(named: "telegram_pasif")
                                      UserDefaults.standard.set(true, forKey: "hideTelegram")

                                  }
                            
                        }
    }
    
    @objc func imageTappedSms(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
             let tappedImage = tapGestureRecognizer.view as! UIImageView
                    
                             if #available(iOS 13.0, *) {
                                 if((tappedImage.image?.description.contains("sms_pasif"))!){
                                           
                                         tappedImage.image = UIImage(named: "sms")
                                         UserDefaults.standard.set(false, forKey: "hideSms")

                                       } else if((tappedImage.image?.description.contains("sms"))!){
                                           
                                           tappedImage.image = UIImage(named: "sms_pasif")
                                           UserDefaults.standard.set(true, forKey: "hideSms")

                                       }
                                 
                             } else {
                                 if(tappedImage.image == UIImage(named:"sms_pasif")){
                                           
                                         tappedImage.image = UIImage(named: "sms")
                                         UserDefaults.standard.set(false, forKey: "hideSms")

                                       } else if(tappedImage.image == UIImage(named:"sms")){
                                           
                                           tappedImage.image = UIImage(named: "sms_pasif")
                                           UserDefaults.standard.set(true, forKey: "hideSms")

                                       }
                                 
                             }
        
    }
}
