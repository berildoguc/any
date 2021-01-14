//
//  PopupContentViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 21.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import M13Checkbox

class PopupContentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet var chkFacebook: UIView!
    @IBOutlet var txtFacebook: UILabel!
    @IBOutlet var edtFacebook: UITextField!
    
    @IBOutlet var txtTwitter: UILabel!
    @IBOutlet var chkTwitter: UIView!
    @IBOutlet var edtTwitter: UITextField!
    
    
    @IBOutlet var txtInstagram: UILabel!
    @IBOutlet var chkInstagram: UIView!
    @IBOutlet var edtInstagram: UITextField!
    
    @IBOutlet weak var txtGmail: UILabel!
    @IBOutlet weak var chkGmail: UIView!
    @IBOutlet weak var edtGmail: UITextField!
    
    @IBOutlet weak var txtNotes: UILabel!
    @IBOutlet weak var chkNotes: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var btnDone: UIImageView!
    @IBOutlet var btnClose: UIImageView!
    @IBOutlet var viewBtnDone: UIView!
    @IBOutlet var viewBtnClose: UIView!
    
    @IBOutlet var snackBarText: UILabel!
    @IBOutlet var snackBar: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    let m13Facebook = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    let m13Twitter = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    let m13Instagram = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    let m13Gmail = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    let m13Notes = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    var highlightedColon = ""
    var lastTab = ""
    var isKeyboardShow = false;
    var userNames:UsernamesItem? = nil
    var contact: ContactItem? = ContactItem(id: "0", firstName: "", middleName: "", familyName: "", phoneNumber: "", isFavorite: "false", img: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)

    
        if(contact?.img != nil){
            imageView.image = UIImage(data: contact!.img!)
        }
        userNames = DbUtil.sharedInstance.getUserNames(contactId: contact!.id)
        edtFacebook.placeholder = NSLocalizedString("example_username", comment: "")
        edtTwitter.placeholder = NSLocalizedString("example_username", comment: "")
        edtInstagram.placeholder = NSLocalizedString("example_username", comment: "")
        edtGmail.placeholder = NSLocalizedString("example_email", comment: "")
        edtFacebook.delegate = self
        edtTwitter.delegate = self
        edtInstagram.delegate = self
        edtGmail.delegate = self
        scrollView.keyboardDismissMode = .interactive

        m13Facebook.secondaryTintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Facebook.tintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Facebook.stateChangeAnimation = .flat(M13Checkbox.AnimationStyle.fill)
        m13Facebook.addTarget(self, action: #selector(self.facebookValueChanged(_:)), for: .valueChanged)

        chkFacebook.addSubview(m13Facebook)
        m13Facebook.frame.origin = CGPoint(x: 13, y: 5.5)

        m13Twitter.secondaryTintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Twitter.tintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Twitter.stateChangeAnimation = .flat(M13Checkbox.AnimationStyle.fill)
        m13Twitter.addTarget(self, action: #selector(self.twitterValueChanged(_:)), for: .valueChanged)
        
        chkTwitter.addSubview(m13Twitter)
        m13Twitter.frame.origin = CGPoint(x: 13, y: 5.5)

        m13Instagram.secondaryTintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Instagram.tintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Instagram.stateChangeAnimation = .flat(M13Checkbox.AnimationStyle.fill)
        m13Instagram.addTarget(self, action: #selector(self.instagramValueChanged(_:)), for: .valueChanged)

        chkInstagram.addSubview(m13Instagram)
        m13Instagram.frame.origin = CGPoint(x: 13, y: 5.5)
        
        m13Gmail.secondaryTintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
               m13Gmail.tintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
               m13Gmail.stateChangeAnimation = .flat(M13Checkbox.AnimationStyle.fill)
               m13Gmail.addTarget(self, action: #selector(self.gmailValueChanged(_:)), for: .valueChanged)

               chkGmail.addSubview(m13Gmail)
               m13Gmail.frame.origin = CGPoint(x: 13, y: 5.5)

        m13Notes.secondaryTintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Notes.tintColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        m13Notes.stateChangeAnimation = .flat(M13Checkbox.AnimationStyle.fill)
        m13Notes.addTarget(self, action: #selector(self.notesValueChanged(_:)), for: .valueChanged)
        
        chkNotes.addSubview(m13Notes)
        m13Notes.frame.origin = CGPoint(x: 13, y: 5.5)

        txtFacebook.text = NSLocalizedString("facebook", comment: "")
        txtTwitter.text = NSLocalizedString("twitter", comment: "")
        txtInstagram.text = NSLocalizedString("instagram", comment: "")
        txtGmail.text = NSLocalizedString("email", comment: "")
        txtNotes.text = NSLocalizedString("notes", comment: "")

        var contactName = contact!.firstName + " " + contact!.middleName
        contactName =  contactName + " " + contact!.familyName
        
        if( contactName == "#  "){
            lblName.text = contact?.phoneNumber
            lblNumber.isHidden = true
            lblName.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor).isActive = true

        }else{
            lblName.text = contactName
            lblNumber.text = contact?.phoneNumber
        }
        if(userNames == nil){
             fbFieldStatus(show: true)
             twitterFieldStatus(show: true)
            instagramFieldStatus(show: true)
            gmailFieldStatus(show: true)
            notesFieldStatus(show: true)

        }else{

            if(userNames?.fbUsername != "" || userNames?.fbUsername != " "){
                edtFacebook.text = userNames?.fbUsername

            }
            if(userNames?.instagramUsername != "" || userNames?.instagramUsername != " "){
                edtInstagram.text = userNames?.instagramUsername

            }
            if(userNames?.twitterUsername != "" || userNames?.twitterUsername != " "){
                edtTwitter.text = userNames?.twitterUsername

            }
            if(userNames?.gmailUsername != "" || userNames?.gmailUsername != " "){
                edtGmail.text = userNames?.gmailUsername

                 }
            if(userNames?.visibilityFbUsername == "1"){
                fbFieldStatus(show: true)
            }else{
                fbFieldStatus(show: false)
            }
            
            if(userNames?.visibilityInstagramUsername == "1"){
                instagramFieldStatus(show: true)

            }else{
                instagramFieldStatus(show: false)

            }
            
            if(userNames?.visibilityTwitterUsername == "1"){
                twitterFieldStatus(show: true)
            }else{
                twitterFieldStatus(show: false)
            }
            if(userNames?.visibilityGmailUsername == "1"){
                        gmailFieldStatus(show: true)
                    }else{
                        gmailFieldStatus(show: false)
                    }
                    
            if(userNames?.visibilityNotes == "1"){
                notesFieldStatus(show: true)
            }else{

                notesFieldStatus(show: false)
            }
        }
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnDoneTapped(tapGestureRecognizer:)))
        viewBtnDone.isUserInteractionEnabled = true
        viewBtnDone.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(btnCloseTapped(tapGestureRecognizer:)))
        viewBtnClose.isUserInteractionEnabled = true
        viewBtnClose.addGestureRecognizer(tapGestureRecognizer2)
        
        viewBtnClose.layer.masksToBounds = false
        viewBtnClose.layer.cornerRadius = viewBtnClose.frame.height/2
        viewBtnClose.clipsToBounds = true
        viewBtnDone.layer.masksToBounds = false
        viewBtnDone.layer.cornerRadius = viewBtnDone.frame.height/2
        viewBtnDone.clipsToBounds = true
        
        viewBtnDone.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        viewBtnClose.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)

        let tapGestureRecognizerFB = UITapGestureRecognizer(target: self, action: #selector(clickChkFb(tapGestureRecognizer:)))
        chkFacebook.isUserInteractionEnabled = true
        chkFacebook.addGestureRecognizer(tapGestureRecognizerFB)
        
        let tapGestureRecognizerTwitter = UITapGestureRecognizer(target: self, action: #selector(clickChkTwitter(tapGestureRecognizer:)))
        chkTwitter.isUserInteractionEnabled = true
        chkTwitter.addGestureRecognizer(tapGestureRecognizerTwitter)
        
        let tapGestureRecognizerInstagram = UITapGestureRecognizer(target: self, action: #selector(clickChkInstagram(tapGestureRecognizer:)))
        chkInstagram.isUserInteractionEnabled = true
        chkInstagram.addGestureRecognizer(tapGestureRecognizerInstagram)
        
        let tapGestureRecognizerGmail = UITapGestureRecognizer(target: self, action: #selector(clickChkGmail(tapGestureRecognizer:)))
             chkGmail.isUserInteractionEnabled = true
             chkGmail.addGestureRecognizer(tapGestureRecognizerGmail)
             
        
        let tapGestureRecognizerNotes = UITapGestureRecognizer(target: self, action: #selector(clickChkNotes(tapGestureRecognizer:)))
        chkNotes.isUserInteractionEnabled = true
        chkNotes.addGestureRecognizer(tapGestureRecognizerNotes)
        
        if(highlightedColon == "fb"){
            self.edtFacebook.backgroundColor =  UIColor(red: 254.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 ) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.edtFacebook.backgroundColor =  UIColor.clear
                })
                
            }
            
        }else if(highlightedColon == "instagram"){
            self.edtInstagram.backgroundColor =  UIColor(red: 254.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 ) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.edtInstagram.backgroundColor =  UIColor.clear
                })
                
            }
        }else if(highlightedColon == "twitter"){
            self.edtTwitter.backgroundColor =  UIColor(red: 254.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 ) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.edtTwitter.backgroundColor =  UIColor.clear
                })
                
            }
        }
        else if(highlightedColon == "gmail"){
            self.edtGmail.backgroundColor =  UIColor(red: 254.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0 ) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.edtGmail.backgroundColor =  UIColor.clear
                })
                
            }
        }
    }

    @objc func clickChkFb(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(m13Facebook.checkState == .checked){
            fbFieldStatus(show: false)
        }else{
            fbFieldStatus(show: true)
            
        }
    }
    
    @objc func clickChkTwitter(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(m13Twitter.checkState == .checked){
            twitterFieldStatus(show: false)
        }else{
            twitterFieldStatus(show: true)
            
        }
    }
    
    @objc func clickChkInstagram(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(m13Instagram.checkState == .checked){
            instagramFieldStatus(show: false)
        }else{
            instagramFieldStatus(show: true)
            
        }
    }
    
    @objc func clickChkGmail(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(m13Gmail.checkState == .checked){
            gmailFieldStatus(show: false)
        }else{
            gmailFieldStatus(show: true)
            
        }
    }
    
    @objc func clickChkNotes(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(m13Notes.checkState == .checked){
            notesFieldStatus(show: false)
        }else{
            notesFieldStatus(show: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let bottom = CGAffineTransform(translationX: 0, y: self.snackBar.frame.height)
        self.snackBar.transform = bottom

      
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.9, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.9, y:1.0)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0), whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.frame = bottomBarView.bounds
        bottomBarView.layer.mask = gradient
        
        lblName.layer.shadowColor = UIColor.black.cgColor
        lblName.layer.shadowRadius = 1.0
        lblName.layer.shadowOpacity = 0.7
        lblName.layer.shadowOffset = CGSize(width: 1, height: 1)
        lblName.layer.masksToBounds = false
        
        lblNumber.layer.shadowColor = UIColor.black.cgColor
        lblNumber.layer.shadowRadius = 1.0
        lblNumber.layer.shadowOpacity = 0.5
        lblNumber.layer.shadowOffset = CGSize(width: 0.7, height: 0.7)
        lblNumber.layer.masksToBounds = false
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func facebookValueChanged(_ sender: M13Checkbox) {
       
        if(sender.checkState.rawValue == "Checked"){
            txtFacebook.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtFacebook.isEnabled = true
        }else{
           txtFacebook.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtFacebook.isEnabled = false
        }
        
    }
    
    @objc func twitterValueChanged(_ sender: M13Checkbox) {
        
        if(sender.checkState.rawValue == "Checked"){
            txtTwitter.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtTwitter.isEnabled = true
        }else{
            txtTwitter.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtTwitter.isEnabled = false
        }
        
    }
    
    @objc func instagramValueChanged(_ sender: M13Checkbox) {
        
        if(sender.checkState.rawValue == "Checked"){
            txtInstagram.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtInstagram.isEnabled = true
        }else{
            txtInstagram.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtInstagram.isEnabled = false
        }
        
    }
    
    
    @objc func gmailValueChanged(_ sender: M13Checkbox) {
        
        if(sender.checkState.rawValue == "Checked"){
            txtGmail.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtGmail.isEnabled = true
        }else{
            txtGmail.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtGmail.isEnabled = false
        }
        
    }
    
    
    @objc func notesValueChanged(_ sender: M13Checkbox) {
        
        if(sender.checkState.rawValue == "Checked"){
            txtNotes.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        }else{
            txtNotes.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        }
        
    }
    
    @objc func btnDoneTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        btnDone.image = UIImage(named: "done_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnDone.image = UIImage(named: "done")
        }
        
        var chkFbFirstStatus = "Unchecked"
        if(userNames?.visibilityFbUsername == "1" || userNames?.visibilityFbUsername == nil){
            chkFbFirstStatus = "Checked"
            
        }
        var chkTwitterFirstStatus = "Unchecked"
        if(userNames?.visibilityTwitterUsername == "1") || userNames?.visibilityTwitterUsername == nil{
            chkTwitterFirstStatus = "Checked"
            
        }
        var chkInstagramFirstStatus = "Unchecked"
        if(userNames?.visibilityInstagramUsername == "1" || userNames?.visibilityInstagramUsername == nil){
            chkInstagramFirstStatus = "Checked"
            
        }
        
        var chkGmailFirstStatus = "Unchecked"
          if(userNames?.visibilityGmailUsername == "1" || userNames?.visibilityGmailUsername == nil){
              chkGmailFirstStatus = "Checked"
              
          }
        
        var chkNotesFirstStatus = "Unchecked"
        if(userNames?.visibilityNotes == "1" || userNames?.visibilityNotes == nil){
            chkNotesFirstStatus = "Checked"
            
        }
        
        if((chkFbFirstStatus != m13Facebook.checkState.rawValue) || (chkTwitterFirstStatus != m13Twitter.checkState.rawValue) || (chkInstagramFirstStatus != m13Instagram.checkState.rawValue) || (chkGmailFirstStatus != m13Gmail.checkState.rawValue) || (edtFacebook.text != ((userNames?.fbUsername == nil) ? "" : userNames?.fbUsername)) || (edtTwitter.text != ((userNames?.twitterUsername == nil) ? "" : userNames?.twitterUsername)) || (edtInstagram.text != ((userNames?.instagramUsername == nil) ? "" : userNames?.instagramUsername)) || (edtGmail.text != ((userNames?.gmailUsername == nil) ? "" : userNames?.gmailUsername)) || chkNotesFirstStatus != m13Notes.checkState.rawValue) {
         
            do {
 
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9-_.].*", options: [])

                if (regex.firstMatch(in: edtFacebook.text!, options: [], range: NSMakeRange(0, edtFacebook.text!.count)) == nil && regex.firstMatch(in: edtTwitter.text!, options: [], range: NSMakeRange(0, edtTwitter.text!.count)) == nil && regex.firstMatch(in: edtInstagram.text!, options: [], range: NSMakeRange(0, edtInstagram.text!.count)) == nil) {
                    if(( validateEmail(enteredEmail: edtGmail.text!) || edtGmail.text!.elementsEqual(""))){

        if(m13Facebook.checkState == .checked || m13Twitter.checkState == .checked || m13Instagram.checkState == .checked || m13Notes.checkState == .checked || m13Gmail.checkState == .checked){
        btnDone.image = UIImage(named: "done_pressed")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.30 ) {
            self.btnDone.image = UIImage(named: "done")

        }
        
 
      
            if(userNames != nil){
                
                DbUtil.sharedInstance.updateUserNames(contactId: contact!.id, fbUsername: edtFacebook.text, twitterUserName: edtTwitter.text, instagramUserName: edtInstagram.text, gmailUserName: edtGmail.text, visibilityFbUsername: m13Facebook.checkState == .checked ? "1":"0", visibilityTwitterUsername: m13Twitter.checkState == .checked ? "1":"0", visibilityInstagramUsername: m13Instagram.checkState == .checked ? "1":"0", visibilityGmailUsername: m13Gmail.checkState == .checked ? "1":"0", visibilityNotes: m13Notes.checkState == .checked ? "1":"0", customTab1Name: userNames?.customTab1Name, customTab2Name: userNames?.customTab2Name, customTab3Name: userNames?.customTab3Name, customTab1Url: userNames?.customTab1Url, customTab2Url: userNames?.customTab2Url, customTab3Url: userNames?.customTab3Url)
            }else{
                DbUtil.sharedInstance.addUserNames(contactId: contact!.id, fbUsername: edtFacebook.text, twitterUserName: edtTwitter.text, instagramUserName: edtInstagram.text, gmailUserName: edtGmail.text, visibilityFbUsername: m13Facebook.checkState == .checked ? "1":"0", visibilityTwitterUsername: m13Twitter.checkState == .checked ? "1":"0", visibilityInstagramUsername: m13Instagram.checkState == .checked ? "1":"0", visibilityGmailUsername: m13Gmail.checkState == .checked ? "1":"0", visibilityNotes: m13Notes.checkState == .checked ? "1":"0", customTab1Name: "", customTab2Name: "", customTab3Name: "", customTab1Url: "", customTab2Url: "", customTab3Url: "")
            }
            
            userNames = DbUtil.sharedInstance.getUserNames(contactId: contact!.id)

         let tabName:[String: String] = ["tabName": lastTab]

            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshPage"), object: nil, userInfo: tabName)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)

        }else{
            snackBar(title: NSLocalizedString("two_tabs_enable", comment: ""), long: true)
        }
         } else {
               snackBar(title: NSLocalizedString("valid_email", comment: ""), long: true)

             }
                    
            } else {
               snackBar(title: NSLocalizedString("valid_username", comment: ""), long: true)

             }
         }
            catch {
                snackBar(title: NSLocalizedString("valid_username", comment: ""), long: true)

            }
        }
        

    }
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    @objc func btnCloseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnClose.image = UIImage(named: "close_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnClose.image = UIImage(named: "close")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)

    }
    
    func fbFieldStatus(show:Bool){
        if(show){
            m13Facebook.checkState = .checked
            txtFacebook.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtFacebook.isEnabled = true
        }else{
            m13Facebook.checkState = .unchecked
            txtFacebook.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtFacebook.isEnabled = false
        }
    }
    
    func twitterFieldStatus(show:Bool){
        if(show){
            m13Twitter.checkState = .checked
            txtTwitter.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtTwitter.isEnabled = true
        }else{
            m13Twitter.checkState = .unchecked
            txtTwitter.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtTwitter.isEnabled = false
        }
    }
    
    func instagramFieldStatus(show:Bool){
        if(show){
            m13Instagram.checkState = .checked
            txtInstagram.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            edtInstagram.isEnabled = true
        }else{
            m13Instagram.checkState = .unchecked
            txtInstagram.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            edtInstagram.isEnabled = false
        }
    }
    
    func gmailFieldStatus(show:Bool){
           if(show){
               m13Gmail.checkState = .checked
               txtGmail.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
               edtGmail.isEnabled = true
           }else{
               m13Gmail.checkState = .unchecked
               txtGmail.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
               edtGmail.isEnabled = false
           }
       }
    
    func notesFieldStatus(show:Bool){
        if(show){
            m13Notes.checkState = .checked
            txtNotes.textColor = UIColor(red: 25.0/255.0, green: 162.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        }else{
            m13Notes.checkState = .unchecked
            txtNotes.textColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        }
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
            
            let hide = CGAffineTransform(translationX: 0, y: self.snackBar.frame.height)
            
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
                self.snackBar.transform = hide
            }, completion: nil)
            
            self.snackBar.isHidden = true

        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                        print("hide")
                    })
              
                }
            } else {
                if(!isKeyboardShow){
                    self.isKeyboardShow = true

                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1 ) {

                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.isKeyboardShow = true
                        self.contentView.frame.origin.y -= keyboardSize.height/2

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
        scrollView.setContentOffset(.zero, animated: true)
   
        return true
    }
  
}

