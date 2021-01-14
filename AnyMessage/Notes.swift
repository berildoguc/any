//
//  Notes.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 9.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class Notes:UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var btnAddNote: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var noteList = [NoteItem]()
    var noteListOriginal = [NoteItem]()
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgNotFound: UIImageView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var not_found_view: UIView!
    var contactID = ""
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    let defaults = UserDefaults.standard
    var content = ""
    var noteID: Int? = nil
    var date = Date()
    @IBOutlet weak var searchBar: UISearchBar!
    var statusBar1 =  UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(contactID != "myProfile"){
            noteList =  DbUtil.sharedInstance.getNotes(contactId: contactID) ?? [NoteItem]()
        }else{
            noteList =  DbUtil.sharedInstance.getNotes(contactId: "myProfile") ?? [NoteItem]()
        }
        
        noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
        noteListOriginal = noteList
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive

        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
        hideMessenger = defaults.bool(forKey: "hideMessenger")
        hideViber = defaults.bool(forKey: "hideViber")
        hideTelegram = defaults.bool(forKey: "hideTelegram")
        hideSms = defaults.bool(forKey: "hideSms")
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeBottomHeight(_:)), name: Notification.Name(rawValue: "changeBottomHeight"), object: nil)
        
        btnAddNote.layer.cornerRadius = 0.5 * btnAddNote.bounds.size.width
        btnAddNote.layer.shadowOpacity = 0.3
        btnAddNote.layer.shadowRadius = 3.0
        btnAddNote.layer.shadowColor = UIColor.black.cgColor
        btnAddNote.layer.masksToBounds = false
        
        btnAddNote.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotes(_:)), name: Notification.Name(rawValue: "reloadNotes"), object: nil)
        searchBar.placeholder = NSLocalizedString("search_word", comment: "")
        searchBar.delegate = self

        
        if(noteList.count == 0){
            lblNotFound.text = NSLocalizedString("no_note_found", comment: "")
            imgNotFound.image = UIImage(named: "not_found_notes")
            tableView.isHidden = true
            not_found_view.isHidden = false
            
        }else if (noteList.count < 2){
           searchBar.isUserInteractionEnabled = false
            
        }
    }
    
    
    @IBAction func addNote(_ sender: Any) {
        btnAddNote.layer.shadowOpacity = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.07 ) {
            self.btnAddNote.layer.shadowOpacity = 0.3
            
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            
            if(contactID != "myProfile"){
                noteList =  DbUtil.sharedInstance.getNotes(contactId: contactID) ?? [NoteItem]()
            }else{
                noteList =  DbUtil.sharedInstance.getNotes(contactId: "myProfile") ?? [NoteItem]()
            }
            noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
            noteListOriginal = noteList
            
            if(noteList.count == 0){
                tableView.isHidden = true
                
                not_found_view.isHidden = false
            }else{
                tableView.isHidden = false
                not_found_view.isHidden = true
            }
            tableView.isScrollEnabled = true

            self.tableView.reloadData()
            
            
        }else{
            noteList = noteListOriginal
            var noteList2: [NoteItem] = [NoteItem]()
            
            for note in noteList {
                if(note.noteContent.lowercased().contains(searchText.lowercased())){
                    noteList2.append(note)
                }
            }
            
            noteList = noteList2;
            
            tableView.reloadData()
            if(noteList.count == 0){
                lblNotFound.text = NSLocalizedString("no_result_for", comment: "") + " \"" + searchText + "\""
                imgNotFound.image = UIImage(named: "not_found_search")
                not_found_view.isHidden = false
                self.view.bringSubviewToFront(not_found_view)
                tableView.isScrollEnabled = false

            }else{
                tableView.isHidden = false
                lblNotFound.text = NSLocalizedString("no_note_found", comment: "")
                imgNotFound.image = UIImage(named: "not_found_notes")
                not_found_view.isHidden = true
                tableView.isScrollEnabled = true

                
            }
            
        }
    }
    

    
    @objc func reloadNotes(_ notification: Notification) {
        if(contactID != "myProfile"){
            noteList =  DbUtil.sharedInstance.getNotes(contactId: contactID) ?? [NoteItem]()
        }else{
            noteList =  DbUtil.sharedInstance.getNotes(contactId: "myProfile") ?? [NoteItem]()
        }
        noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
        noteListOriginal = noteList

        if(noteList.count == 0){
            lblNotFound.text = NSLocalizedString("no_note_found", comment: "")
            imgNotFound.image = UIImage(named: "not_found_notes")
            tableView.isHidden = true
            not_found_view.isHidden = false
            
        }else{
            if(noteList.count < 2){
                searchBar.isUserInteractionEnabled = false
            }else{
                searchBar.isUserInteractionEnabled = true

            }
         
            tableView.isHidden = false
            not_found_view.isHidden = true
        }
        tableView.isScrollEnabled = true

        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if segue.identifier == "segueNotePopup" {
            if #available(iOS 13.0, *) {

                   statusBar1.frame = (UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame)!
                     UIApplication.shared.keyWindow?.addSubview(statusBar1)

                  } else {

                     statusBar1 = UIApplication.shared.value(forKey: "statusBar") as! UIView
                  }
               
               statusBar1.backgroundColor = UIColor.clear
            guard let popupViewController = segue.destination as? PopupNote else { return }
            popupViewController.customBlurEffectStyle = UIBlurEffect.Style.regular
            
            popupViewController.customAnimationDuration = TimeInterval(0.5)
            popupViewController.customInitialScaleAmmount = CGFloat(Double(0.5))
            popupViewController.contactID = contactID
            if(noteID != nil){
                popupViewController.noteID = self.noteID
                popupViewController.content = self.content
                popupViewController.date = self.date
                popupViewController.fromMainPage = false

                noteID = nil
                content = ""
            }
            
        }
  
         
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote", for: indexPath as IndexPath) as! CellNote
        
        cell.lblContent.text = self.noteList[indexPath.item].noteContent
        
        
        let date = self.noteList[indexPath.item].noteDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        
        let shortDateString = "\(dateFormatter.string(from: date))"
        let time = "\(timeFormatter.string(from: date))"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let dateData: String = dateFormatter2.string(from: date)
        let nowDate: String = dateFormatter2.string(from: Date())
        
        
        if(dateData != nowDate){
            cell.lblDate.text = shortDateString
        }else{
            cell.lblDate.text = time
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        content = self.noteList[indexPath.item].noteContent
        date = self.noteList[indexPath.item].noteDate
        noteID = self.noteList[indexPath.item].noteID
        performSegue(withIdentifier: "segueNotePopup", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    @objc func changeBottomHeight(_ notification: Notification) {
        bottomConstraint.constant = 0
        btnBottomConstraint.constant = 20
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hideTabBar"), object: nil)
            self.topConstraint.constant = 0
            
            
            
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabBar"), object: nil)
            
            if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
                topConstraint.constant = 40
                
            }else{
                
                topConstraint.constant = 275
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
}
