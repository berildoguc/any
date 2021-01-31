//
//  AllNotes.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 20.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds

class AllNotes: UIViewController, UITableViewDelegate, UITableViewDataSource, FBAdViewDelegate, GADBannerViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var btnMyProfile: UIBarButtonItem!
    @IBOutlet var adView: UIView!
    @IBOutlet weak var adViewContainer: UIView!
    var bannerViewFacebook: FBAdView!
    var bannerViewAdmob: GADBannerView!
    let searchBar:UISearchBar = UISearchBar()
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var notFoundViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var noteList = [NoteItem]()
    var noteListOriginal = [NoteItem]()
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
    var listContacts = [ContactItem]()
    var statusBar1 =  UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()

        noteList =  DbUtil.sharedInstance.getAllNotes() ?? [NoteItem]()

       
        noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
        noteListOriginal = noteList
       
        searchBar.placeholder = NSLocalizedString("search_word", comment: "")
        searchBar.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.titleView = searchBar
        
        //btnMyProfile.image = UIImage(named:"my_profile")?.withRenderingMode(.alwaysOriginal)
        lblNotFound.text = NSLocalizedString("no_favorite_found", comment: "")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive

        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
        hideMessenger = defaults.bool(forKey: "hideMessenger")
        hideViber = defaults.bool(forKey: "hideViber")
        hideTelegram = defaults.bool(forKey: "hideTelegram")
        hideSms = defaults.bool(forKey: "hideSms")
                
      
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotes(_:)), name: Notification.Name(rawValue: "reloadNotes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTabbar(_:)), name: Notification.Name(rawValue: "showTabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetList(_:)), name: Notification.Name(rawValue: "resetList"), object: nil)

        
        if(noteList.count == 0){
            lblNotFound.text = NSLocalizedString("no_note_found", comment: "")
            imgNotFound.image = UIImage(named: "not_found_notes")
            tableView.isHidden = true
            not_found_view.isHidden = false
            searchBar.isUserInteractionEnabled = false

        }else if (noteList.count < 2){
            searchBar.isUserInteractionEnabled = false
            
        }
        
        
        bannerViewFacebook = FBAdView(placementID: "1261484220642800_1261491200642102", adSize: kFBAdSize320x50, rootViewController: self)
        bannerViewFacebook.delegate = self
        
        
        adView.addSubview(bannerViewFacebook)
        bannerViewFacebook.frame.size = CGSize(width: view.frame.size.width, height: 50)
        
        
        bannerViewFacebook.loadAd()
    }
    
    

    
    
    // FACEBOOK ADS FUNCTIONS
    func adViewDidLoad(_ adView: FBAdView) {
        print("yüklendi facebook reklam")

    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("hata facebook reklam: " + error.localizedDescription)
        
        self.bannerViewAdmob = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerViewAdmob.delegate = self
        self.bannerViewAdmob.adUnitID = "ca-app-pub-8886884732302136/5104072195"
        self.bannerViewAdmob.rootViewController = self
        self.bannerViewAdmob.load(GADRequest())
        self.bannerViewAdmob.translatesAutoresizingMaskIntoConstraints = false
        bannerViewFacebook.isHidden = true
        self.adView.addSubview(bannerViewAdmob)
        
        self.adView.addConstraints(
            [NSLayoutConstraint(item: bannerViewAdmob,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: adView,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerViewAdmob)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerViewAdmob)
        }
        
        
    }
    
    // ADMOB FUNCTIONS
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("yüklendi admob reklam")

    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("hata admob reklam: \(error.localizedDescription)")
        adViewContainer.isHidden = true
        adViewContainer.frame.size = CGSize(width: adView.frame.width, height: 0)
        tableViewBottom.constant = 0
        notFoundViewBottom.constant = 0
    }
    
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            
           resetNotes()
            
            
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
                tableView.isHidden = true
                lblNotFound.text = NSLocalizedString("no_result_for", comment: "") + " \"" + searchText + "\""
                imgNotFound.image = UIImage(named: "not_found_search")
                not_found_view.isHidden = false
                
            }else{
                tableView.isHidden = false
                lblNotFound.text = NSLocalizedString("no_favorite_found", comment: "")
                imgNotFound.image = UIImage(named: "not_found_favorite")
                not_found_view.isHidden = true
                
            }
        
            
        }
    }
    
    
    func resetNotes(){
        
        noteList =  DbUtil.sharedInstance.getAllNotes() ?? [NoteItem]()
                   noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
                   noteListOriginal = noteList
                   
                   if(noteList.count == 0){
                       tableView.isHidden = true
                       
                       not_found_view.isHidden = false
                   }else{
                       tableView.isHidden = false
                       not_found_view.isHidden = true
                   }
                   
                   self.tableView.reloadData()
    }
    
    @objc func resetList(_ notification: Notification){

        if searchBar.text != nil && searchBar.text != ""{

            searchBar.text = ""
            searchBar.resignFirstResponder()
            
            noteList =  DbUtil.sharedInstance.getAllNotes() ?? [NoteItem]()
                              noteList = noteList.sorted(by: { $0.noteDate > $1.noteDate})
                              noteListOriginal = noteList
                              
                              if(noteList.count == 0){
                                  tableView.isHidden = true
                                  
                                  not_found_view.isHidden = false
                              }else{
                                  tableView.isHidden = false
                                  not_found_view.isHidden = true
                              }
                              
                              self.tableView.reloadData()
            
                  }
       
    }
    
    @objc func reloadNotes(_ notification: Notification) {
        noteList =  DbUtil.sharedInstance.getAllNotes() ?? [NoteItem]()

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
        
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if segue.identifier == "segueNotePopup" {
            
            guard let popupViewController = segue.destination as? PopupNote else { return }
            popupViewController.customBlurEffectStyle = UIBlurEffect.Style.regular
            
            popupViewController.customAnimationDuration = TimeInterval(0.5)
            popupViewController.customInitialScaleAmmount = CGFloat(Double(0.5))
            popupViewController.contactID = contactID
            if(noteID != nil){
                popupViewController.noteID = self.noteID
                popupViewController.content = self.content
                popupViewController.date = self.date
                popupViewController.fromMainPage = true
                noteID = nil
                content = ""
            }
            
        }
        if #available(iOS 13.0, *) {

             statusBar1.frame = (UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame)!
               UIApplication.shared.keyWindow?.addSubview(statusBar1)

            } else {

               statusBar1 = UIApplication.shared.value(forKey: "statusBar") as! UIView
            }
         
         statusBar1.backgroundColor = UIColor.clear
         
        self.tabBarController?.tabBar.isHidden = true

        var frame = self.tabBarController?.tabBar.frame
        frame!.origin.y = self.view.frame.size.height + (frame?.size.height)!
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame = frame!

        })
       
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcSettings") as? SettingsViewController {
            if let navigator = self.navigationController {
                
                viewController.navigationItem.hidesBackButton = false
                viewController.hidesBottomBarWhenPushed = true
                navigator.pushViewController(viewController, animated: true)
                
                
            }
        }
    }
    
    @IBAction func btnMyProfile(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcProfile") as? ProfileViewController {
            if let navigator = self.navigationController {
                
                viewController.navigationItem.hidesBackButton = false
                viewController.hidesBottomBarWhenPushed = true
                navigator.pushViewController(viewController, animated: true)
                
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAllNote", for: indexPath as IndexPath) as! CellAllNote
        
        cell.lblContent.text = self.noteList[indexPath.item].noteContent
        
        
        let date = self.noteList[indexPath.item].noteDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        
        let time = "\(dateFormatter.string(from: date)), \(timeFormatter.string(from: date))"
        cell.lblDate.text = time
     
       
        if(noteList[indexPath.item].contactID != "myProfile"){
        for i in 0..<listContacts.count {
            if(listContacts[i].id == noteList[indexPath.item].contactID){
                   let contactName = listContacts[i].firstName + " " + listContacts[i].middleName + " " + listContacts[i].familyName
                
                if(contactName == "#  "){
                    
                    cell.lblName.text = listContacts[i].phoneNumber
                    cell.bubbleFirstLetter.text = String(listContacts[i].phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").prefix(2))
                }else{
                    cell.lblName.text = listContacts[i].firstName + " " + listContacts[i].middleName + " " + listContacts[i].familyName
                    cell.bubbleFirstLetter.text = String(cell.lblName.text!.prefix(1))
                    
                }
          
                
                if(listContacts[i].img != nil){
                    cell.bubble.image = UIImage(data: listContacts[i].img!)
                    cell.bubbleFirstLetter.isHidden = true
                }else{
                    cell.bubble.image = UIImage(named: "contactsBubbleBackground")
                    cell.bubbleFirstLetter.isHidden = false
                }
            }
            
          }
        }else{
            cell.lblName.text = NSLocalizedString("you", comment: "")
            cell.bubbleFirstLetter.text = String(cell.lblName.text!.prefix(1))
            cell.bubbleFirstLetter.isHidden = false
            cell.bubble.image = UIImage(named: "contactsBubbleBackground")

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
        
        if searchBar.text != nil && searchBar.text != ""{
                  searchBar.text = ""
                  resetNotes()
           }
        
    }


     @objc func showTabbar(_ notification: Notification) {
        self.tabBarController?.tabBar.isHidden = false

        var frame = self.tabBarController?.tabBar.frame
        frame!.origin.y = self.view.frame.size.height - (frame?.size.height)!
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
        

    }
}
