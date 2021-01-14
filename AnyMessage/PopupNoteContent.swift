//
//  PopupNoteContent.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 13.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//
import UIKit

class PopupNoteContent: UIViewController {

    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnDone: UIView!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var btnClose: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var btnDelete: UIView!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var btnShare: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    var contactID = ""
    var now = Date()
    var nowString = ""
    var noteID: Int? = nil
    var content = ""
    var date = Date()
    var fromMainPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)

        btnDone.layer.shadowOpacity = 0.3
        btnDone.layer.shadowRadius = 2.0
        btnDone.layer.shadowColor = UIColor.black.cgColor
        btnDone.layer.masksToBounds = false
        
        btnDone.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        btnClose.layer.shadowOpacity = 0.3
        btnClose.layer.shadowRadius = 2.0
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.masksToBounds = false
        
        btnClose.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        btnDelete.layer.shadowOpacity = 0.3
        btnDelete.layer.shadowRadius = 2.0
        btnDelete.layer.shadowColor = UIColor.black.cgColor
        btnDelete.layer.masksToBounds = false
        
        btnDelete.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        btnShare.layer.shadowOpacity = 0.3
        btnShare.layer.shadowRadius = 2.0
        btnShare.layer.shadowColor = UIColor.black.cgColor
        btnShare.layer.masksToBounds = false
        
        btnShare.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(btnDoneTapped(tapGestureRecognizer:)))
        btnDone.isUserInteractionEnabled = true
        btnDone.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(btnCloseTapped(tapGestureRecognizer:)))
        btnClose.isUserInteractionEnabled = true
        btnClose.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(btnDeleteTapped(tapGestureRecognizer:)))
        btnDelete.isUserInteractionEnabled = true
        btnDelete.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(btnShareTapped(tapGestureRecognizer:)))
        btnShare.isUserInteractionEnabled = true
        btnShare.addGestureRecognizer(tapGestureRecognizer4)
        
        btnClose.layer.masksToBounds = false
        btnClose.layer.cornerRadius = btnClose.frame.height/2
        btnClose.clipsToBounds = true
        btnDone.layer.masksToBounds = false
        btnDone.layer.cornerRadius = btnDone.frame.height/2
        btnDone.clipsToBounds = true
        btnDelete.layer.masksToBounds = false
        btnDelete.layer.cornerRadius = btnDone.frame.height/2
        btnDelete.clipsToBounds = true
        btnShare.layer.masksToBounds = false
        btnShare.layer.cornerRadius = btnDone.frame.height/2
        btnShare.clipsToBounds = true
        
        btnDone.backgroundColor = UIColor.groupTableViewBackground
        btnClose.backgroundColor = UIColor.groupTableViewBackground
        btnDelete.backgroundColor = UIColor.groupTableViewBackground
        btnShare.backgroundColor = UIColor.groupTableViewBackground

        viewContent.layer.masksToBounds = false
        viewContent.layer.cornerRadius = 10
        viewContent.clipsToBounds = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        nowString = df.string(from: now)
        txtContent.keyboardDismissMode = .interactive
        if(noteID == nil){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2 ) {
                self.txtContent.becomeFirstResponder()
            }

        let time = "\(dateFormatter.string(from: now)), \(timeFormatter.string(from: now))"
        
            txtDate.text = time

        }else{
            btnDelete.isHidden = false
            let time = "\(dateFormatter.string(from: date)), \(timeFormatter.string(from: date))"

            txtContent.text = content
            txtDate.text = time

        }
    }
    @objc func btnDoneTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnDone.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnDone.backgroundColor = UIColor.groupTableViewBackground
        }
        
        if(noteID == nil){
            DbUtil.sharedInstance.addNote(contactID: contactID, noteContent: txtContent.text, noteDate: nowString)

        }else{
            DbUtil.sharedInstance.updateNote(ID: noteID!, noteContent: txtContent.text, noteDate: nowString)

        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadNotes"), object: nil)
        if(fromMainPage){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabbar"), object: nil)
        }
    }
    
    @objc func btnCloseTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnClose.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnClose.backgroundColor = UIColor.groupTableViewBackground
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)
        if(fromMainPage){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabbar"), object: nil)
        }
    }
    
    @objc func btnDeleteTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnDelete.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnDelete.backgroundColor = UIColor.groupTableViewBackground
        }
        if(noteID != nil){
  
            let alert = UIAlertController(title: NSLocalizedString("delete_note_warning", comment: ""), message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: { action in


            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { action in
                DbUtil.sharedInstance.deleteNote(ID: self.noteID!)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadNotes"), object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissDialog"), object: nil)
                if(self.fromMainPage){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabbar"), object: nil)
                }
         
            }))
            
            self.present(alert, animated: true)
            
        }
        

    }
    
    @objc func btnShareTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnShare.backgroundColor = UIColor.lightGray
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05 ) {
            self.btnShare.backgroundColor = UIColor.groupTableViewBackground
        }
        
        if(txtContent.text != ""){
        let text = txtContent.text
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
       
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 10.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = ((endFrame?.size.height)!+10) - ((UIScreen.main.bounds.size.height - self.view.bounds.size.height)/2)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    

}
