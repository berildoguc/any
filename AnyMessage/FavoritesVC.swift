//
//  FavoritesVC.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 12.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import Contacts
import FBAudienceNetwork
import GoogleMobileAds

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FBAdViewDelegate, GADBannerViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var imgNotFound: UIImageView!
    @IBOutlet weak var not_found_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    var favoriteList: [ContactItem] = [ContactItem]()
    var favoriteListOriginal: [ContactItem] = [ContactItem]()
    @IBOutlet var btnMyProfile: UIBarButtonItem!
    @IBOutlet var adView: UIView!
    @IBOutlet weak var adViewContainer: UIView!
    var bannerViewFacebook: FBAdView!
    var bannerViewAdmob: GADBannerView!
    let searchBar:UISearchBar = UISearchBar()
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var notFoundViewBottom: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    private let spacing:CGFloat = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom:0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        // self.navigationItem.titleView?.isHidden = true
        searchBar.placeholder = NSLocalizedString("search_word", comment: "")
        searchBar.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.titleView = searchBar
        
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
            favoriteListOriginal = favoriteList
            
        }
        tableView.keyboardDismissMode = .interactive
        
        //btnMyProfile.image = UIImage(named:"my_profile")?.withRenderingMode(.alwaysOriginal)
        lblNotFound.text = NSLocalizedString("no_favorite_found", comment: "")
        imgNotFound.image = UIImage(named: "not_found_favorites")
        
        if(favoriteList.count == 0){
            //tableView.isHidden = true
            not_found_view.isHidden = false
            searchBar.isUserInteractionEnabled = false
            
        }else if (favoriteList.count < 2){
            searchBar.isUserInteractionEnabled = false
            
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: Notification.Name(rawValue: "reloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetList(_:)), name: Notification.Name(rawValue: "resetList"), object: nil)
        
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
    
    
    
    // Set editing mode to show 3 bars on right hand side
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    
    // Determine if a paticular row can be moved
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Determines if tableview indents whislt editing
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favoriteList[sourceIndexPath.row]
        favoriteList.remove(at: sourceIndexPath.row)
        favoriteList.insert(itemToMove, at: destinationIndexPath.row)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
        defaults.set(encodedData, forKey: "favoriteList")
        defaults.synchronize()
        
        if(favoriteList.count == 0){
            //tableView.isHidden = true
            
            not_found_view.isHidden = false
        }else{
            tableView.isHidden = false
            not_found_view.isHidden = true
        }
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: FavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoritesTableViewCell
        
        let contactName = favoriteList[indexPath.row].firstName+" "+favoriteList[indexPath.row].middleName+" "+favoriteList[indexPath.row].familyName
        
        if(contactName == "#  "){
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! FavoritesTableViewCell
            cell.lblName.text = favoriteList[indexPath.row].phoneNumber
            cell.bubbleFirstLetter.text = String(favoriteList[indexPath.row].phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").prefix(2))
        }else{
            cell.lblName.text = favoriteList[indexPath.row].firstName+" "+favoriteList[indexPath.row].middleName+" "+favoriteList[indexPath.row].familyName
            cell.bubbleFirstLetter.text = String(cell.lblName.text!.prefix(1))
            
        }
        
        cell.lblTel.text = favoriteList[indexPath.row].phoneNumber
        cell.bubble.image = UIImage(named: "contactsBubbleBackground")
        cell.bubbleFirstLetter.isHidden = false
        
        if(favoriteList[indexPath.row].img != nil){
            cell.bubble.image = UIImage(data: favoriteList[indexPath.row].img!)
            cell.bubbleFirstLetter.isHidden = true
        }
        
        cell.dial.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer (target: self, action: #selector(callTabbed))
        
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.numberOfTouchesRequired = 1
        cell.dial.accessibilityIdentifier = String(indexPath.row)
        
        cell.dial.addGestureRecognizer(tapGesture1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcDetails") as? DetailsViewController {
            if let navigator = self.navigationController {
                
                if(favoriteList[indexPath.row].firstName + " " + favoriteList[indexPath.row].middleName + " " + favoriteList[indexPath.row].familyName == "#  "){
                    viewController.title =  favoriteList[indexPath.row].phoneNumber
                }else{
                    viewController.title =  favoriteList[indexPath.row].firstName + " " + favoriteList[indexPath.row].middleName + " " + favoriteList[indexPath.row].familyName
                }
                
                viewController.contact = favoriteList[indexPath.row]
                viewController.navigationItem.hidesBackButton = false
                viewController.hidesBottomBarWhenPushed = true
                navigator.pushViewController(viewController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
                
                if searchBar.text != nil && searchBar.text != ""{
                    searchBar.text = ""
                    resetContacts()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcDetails") as? DetailsViewController {
            if let navigator = self.navigationController {
                
                if(favoriteList[indexPath.row].firstName + " " + favoriteList[indexPath.row].middleName + " " + favoriteList[indexPath.row].familyName == "#  "){
                    viewController.title =  favoriteList[indexPath.row].phoneNumber
                }else{
                    viewController.title =  favoriteList[indexPath.row].firstName + " " + favoriteList[indexPath.row].middleName + " " + favoriteList[indexPath.row].familyName
                }
                
                viewController.contact = favoriteList[indexPath.row]
                viewController.navigationItem.hidesBackButton = false
                viewController.hidesBottomBarWhenPushed = true
                navigator.pushViewController(viewController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
                
                if searchBar.text != nil && searchBar.text != ""{
                    searchBar.text = ""
                    resetContacts()
                }
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            
            resetContacts()
            
        }else{
            favoriteList = favoriteListOriginal
            var favoriteList2: [ContactItem] = [ContactItem]()
            
            for contact in favoriteList {
                if((contact.firstName+" "+contact.middleName+" "+contact.familyName + " " + contact.phoneNumber).lowercased().contains(searchText.lowercased())){
                    favoriteList2.append(contact)
                }
            }
            
            favoriteList = favoriteList2;
            tableView.isEditing = false
            
            collectionView.reloadData()
            //tableView.reloadData()
            if(favoriteList.count == 0){
                //tableView.isHidden = true
                lblNotFound.text = NSLocalizedString("no_result_for", comment: "") + " \"" + searchText + "\""
                imgNotFound.image = UIImage(named: "not_found_search")
                not_found_view.isHidden = false
            }else{
                //tableView.isHidden = false
                lblNotFound.text = NSLocalizedString("no_favorite_found", comment: "")
                imgNotFound.image = UIImage(named: "not_found_favorite")
                not_found_view.isHidden = true
            }
            
        }
    }
    
    func resetContacts(){
        print("1984 resetContacts")
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
            favoriteListOriginal = favoriteList
        }
        if(favoriteList.count == 0){
            //tableView.isHidden = true
            not_found_view.isHidden = false
        }else{
            //tableView.isHidden = false
            not_found_view.isHidden = true
        }
        tableView.isEditing = true
        
        self.collectionView.reloadData()
       // self.tableView.reloadData()
    }
    
    @objc func resetList(_ notification: Notification){
        if searchBar.text != nil && searchBar.text != ""{
            
            searchBar.text = ""
            searchBar.resignFirstResponder()
            if(defaults.object(forKey: "favoriteList") != nil){
                let decoded  = defaults.object(forKey: "favoriteList") as! Data
                favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
                favoriteListOriginal = favoriteList
            }
            if(favoriteList.count == 0){
                tableView.isHidden = true
                
                not_found_view.isHidden = false
            }else{
                tableView.isHidden = false
                not_found_view.isHidden = true
            }
            tableView.isEditing = true
            
            self.collectionView.reloadData()
            //self.tableView.reloadData()
        }
    }
    
    @objc func reloadData(_ notification: Notification) {
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
            favoriteListOriginal = favoriteList
        }
        if(favoriteList.count == 0){
            tableView.isHidden = true
            not_found_view.isHidden = false
        }else{
            tableView.isHidden = false
            not_found_view.isHidden = true
            
        }
        
        if(favoriteList.count > 1){
            
            searchBar.isUserInteractionEnabled = true
        }else{
            
            searchBar.isUserInteractionEnabled = false
            
        }
        collectionView.reloadData()
        //tableView.reloadData()
    }
    
    @objc func callTabbed(sender: UITapGestureRecognizer ) {
        
        let row =  Int(sender.view!.accessibilityIdentifier!)
        
        if let cell: FavoritesTableViewCell = tableView?.cellForRow(at: IndexPath(row: row!, section: 0)) as? FavoritesTableViewCell {
            cell.imgDial.image = UIImage(named: "dial_pressed")
            DispatchQueue.main.asyncAfter(deadline: .now()+0.10 ) {
                cell.imgDial.image = UIImage(named: "dial")
            }
        }
        
        var phone = favoriteList[row!].phoneNumber
        phone = phone.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        dialNumber(number: phone)
    }
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
}

extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 14
        
        let totalSpacing = (3 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 150)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("188444 : " , favoriteList.count)
        return favoriteList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("188444 : hey")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? ContactCollectionCell {
            
            // let contactsSectionTitle = favoriteList[indexPath.section]
            print("188444 : hello")
            
            cell.image.image = UIImage(named: "contactsBubbleBackground")
            
            let contactName = favoriteList[indexPath.row].firstName+" "+favoriteList[indexPath.row].middleName+" "+favoriteList[indexPath.row].familyName
            
            
            print("188444 : " ,contactName)
            if(contactName == "#  "){
                cell.nameLabel.text = favoriteList[indexPath.row].phoneNumber
                
            }else{
                cell.nameLabel.text = favoriteList[indexPath.row].firstName+" "+favoriteList[indexPath.row].middleName+" "+favoriteList[indexPath.row].familyName
            }
            
            if(favoriteList[indexPath.row].img != nil){
                cell.image.image = UIImage(data: favoriteList[indexPath.row].img!)
                
            }
            
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
}
