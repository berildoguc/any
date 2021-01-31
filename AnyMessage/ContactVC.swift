    //
    //  ContactVC.swift
    //  Message Core
    //
    //  Created by Haydar Kardeşler on 20.08.2018.
    //  Copyright © 2018 Haydar Kardeşler. All rights reserved.
    //
    
    import UIKit
    import Contacts
    import FBAudienceNetwork
    import GoogleMobileAds
    
    class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FBAdViewDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
        
        @IBOutlet weak var not_found_view: UIView!
        @IBOutlet weak var imgNotFound: UIImageView!
        @IBOutlet weak var lblNotFound: UILabel!
        var contactsDictionary = [String: [ContactItem]]()
        var contactsSectionTitles = [String]()
        var listContacts = [ContactItem]()
        var articles = [ContactItem]()
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var tableView: UITableView!
        let searchBar:UISearchBar = UISearchBar()
        var scrollViewLastValue: CGFloat = 0.0
        let defaults = UserDefaults.standard
        @IBOutlet var btnMyProfile: UIBarButtonItem!
        @IBOutlet var adView: UIView!
        @IBOutlet weak var adViewContainer: UIView!
        var bannerViewFacebook: FBAdView!
        var bannerViewAdmob: GADBannerView!
        @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
        @IBOutlet weak var notFoundViewBottom: NSLayoutConstraint!
        var customWalkthroughView: CustomWalkthroughView? { return walkthroughView as? CustomWalkthroughView }
        var photoCount = 0
        var imgFinger = UIImageView()
        var timer = Timer()
        var tipShowing = false;
        private let spacing:CGFloat = 14
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            for contact in listContacts {
                let nameKey = String(contact.firstName.prefix(1))
                if var nameValues = contactsDictionary[nameKey] {
                    nameValues.append(contact)
                    contactsDictionary[nameKey] = nameValues
                } else {
                    contactsDictionary[nameKey] = [contact]
                }
                
            }
            
            navigationController?.navigationBar.shadowImage = UIImage()
            
            //btnMyProfile.image = UIImage(named:"my_profile")?.withRenderingMode(.alwaysOriginal)
            lblNotFound.text = NSLocalizedString("no_contact_found", comment: "")
            searchBar.placeholder = NSLocalizedString("search_word", comment: "")
            searchBar.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            searchBar.searchBarStyle = .minimal
            searchBar.delegate = self
            searchBar.returnKeyType = UIReturnKeyType.done
            
            self.navigationItem.titleView = searchBar
            
            //tableView.delegate = self
            //tableView.dataSource = self
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom:0, right: spacing)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            self.collectionView?.collectionViewLayout = layout
            
            contactsSectionTitles = [String](contactsDictionary.keys)
            
            contactsSectionTitles = contactsSectionTitles.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending  })
            for i in 0 ..< contactsSectionTitles.count {
                if(contactsSectionTitles[i] == "#"){
                    contactsSectionTitles.remove(at: i)
                    contactsSectionTitles.append("#")
                    
                    break
                }
            }
            
            tableView.sectionIndexColor = UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            tableView.separatorColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
            
            if(listContacts.count == 0){
                lblNotFound.text = NSLocalizedString("no_contact_found", comment: "")
                imgNotFound.image = UIImage(named: "not_found_contact")
                //tableView.isHidden = true
                not_found_view.isHidden = false
                searchBar.isUserInteractionEnabled = false
                
            }else if (listContacts.count < 2){
                searchBar.isUserInteractionEnabled = false
                
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(reloadDataContacts(_:)), name: Notification.Name(rawValue: "reloadDataContacts"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(resetList(_:)), name: Notification.Name(rawValue: "resetList"), object: nil)
            
            bannerViewFacebook = FBAdView(placementID: "1261484220642800_1261491200642102", adSize: kFBAdSize320x50, rootViewController: self)
            bannerViewFacebook.delegate = self
            
            adView.addSubview(bannerViewFacebook)
            bannerViewFacebook.frame.size = CGSize(width: view.frame.size.width, height: 50)
            
            
            bannerViewFacebook.loadAd()
            tableView.keyboardDismissMode = .interactive
            
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                var favoriteList = [ContactItem]()
                if(self.defaults.object(forKey: "favoriteList") != nil){
                    
                    let decoded  = self.defaults.object(forKey: "favoriteList") as! Data
                    favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
                    
                }
                
                for item in favoriteList {
                    var delete = true
                    for j in 0..<self.listContacts.count {
                        if(item.id == self.listContacts[j].id){
                            delete = false
                        }
                    }
                    if(delete){
                        for i in 0..<favoriteList.count {
                            if(item.id == favoriteList[i].id){
                                favoriteList.remove(at: i)
                                break
                            }
                        }
                    }
                }
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
                self.defaults.set(encodedData, forKey: "favoriteList")
                self.defaults.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                
                let sessionCount = self.defaults.integer(forKey: "sessionCount")
                
                if(sessionCount < 2 && self.listContacts.count > 0){
                    self.showTip()
                    
                }
            }
            
        }
        
        func showTip() {
            tipShowing = true
            startWalkthrough(CustomWalkthroughView())
            
            var indexPath = IndexPath(row: 1, section: 0)
            var indexPath2 = IndexPath(row: 0, section: 1)
            
            if(self.listContacts.count == 1){
                indexPath = IndexPath(row: 0, section: 0)
                indexPath2 = IndexPath(row: 0, section: 0)
            }
            let cell = tableView.cellForRow(at: indexPath) ?? tableView.cellForRow(at: indexPath2)
            
            walkthroughView?.cutHolesForViewDescriptors([ViewDescriptor(view: cell!, extraPaddingX: 20, extraPaddingY: 10, cornerRadius: 10)])
            
            
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
            customWalkthroughView!.addGestureRecognizer(gesture)
            
            let finger: UIImage = UIImage(named: "finger")!
            imgFinger = UIImageView(image: finger)
            imgFinger.frame = CGRect(x: ((cell?.frame.width)!-140),y: cell!.center.y+100,width: 90,height: 100)
            customWalkthroughView?.addSubview(imgFinger)
            timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(onTransition), userInfo: nil, repeats: true)
         
            customWalkthroughView?.helpLabel.isHidden = false
            customWalkthroughView?.helpLabel.text = NSLocalizedString("tap_contact_row", comment: "")
            customWalkthroughView?.helpLabel.frame = CGRect(x: 20, y: imgFinger.center.y+50, width: ((cell?.frame.width)!-40), height: 80)
        }
        
        @objc func onTransition() {
            if (photoCount == 0){
                
                UIView.transition(with: imgFinger, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.imgFinger.image = UIImage(named:"finger_2")
                }, completion: nil)
                
                photoCount = 1
            }else{
                UIView.transition(with: imgFinger, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.imgFinger.image = UIImage(named:"finger")
                }, completion: nil)
                photoCount = 0
            }
        }
        
        @objc func checkAction(sender : UITapGestureRecognizer) {
            tipShowing = false
            timer.invalidate()
            
            finishWalkthrough()
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
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return contactsSectionTitles.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let nameKey = contactsSectionTitles[section]
            if let nameValues = contactsDictionary[nameKey] {
                
                return nameValues.count
                
            }
            
            return 0
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell: ContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactsTableViewCell
            
            let nameKey = contactsSectionTitles[indexPath.section]
            if let nameValues = contactsDictionary[nameKey] {
                
                let contactName = nameValues[indexPath.row].firstName+" "+nameValues[indexPath.row].middleName+" "+nameValues[indexPath.row].familyName
                
                if(contactName == "#  "){
                    cell.lblName.text = nameValues[indexPath.row].phoneNumber
                    cell.lblTel.text = nameValues[indexPath.row].phoneNumber
                    cell.bubbleFirstLetter.text = String(nameValues[indexPath.row].phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").prefix(2))
                }else{
                    cell.lblName.text = nameValues[indexPath.row].firstName+" "+nameValues[indexPath.row].middleName+" "+nameValues[indexPath.row].familyName
                    cell.bubbleFirstLetter.text = String(cell.lblName.text!.prefix(1))
                    cell.lblTel.text = nameValues[indexPath.row].phoneNumber
                }
                
                cell.bubble.image = UIImage(named: "contactsBubbleBackground")
                cell.bubbleFirstLetter.isHidden = false
                
                if(nameValues[indexPath.row].img != nil){
                    cell.bubble.image = UIImage(data: nameValues[indexPath.row].img!)
                    cell.bubbleFirstLetter.isHidden = true
                }
                cell.imgDial.image = UIImage(named: "dial")
                
                cell.btnDial.isUserInteractionEnabled = true
                let tapGesture1 = UITapGestureRecognizer (target: self, action: #selector(callTabbed))
                
                tapGesture1.numberOfTapsRequired = 1
                tapGesture1.numberOfTouchesRequired = 1
                cell.btnDial.accessibilityIdentifier = String(indexPath.row) + "," + String(indexPath.section)
                cell.btnDial.addGestureRecognizer(tapGesture1)
                
  
                if(nameValues[indexPath.row].isFavorite == "true"){
                    cell.imgStar.isHidden = false
                }else{
                    cell.imgStar.isHidden = true
                }
            }
            
            return cell
        }
        
        @objc func callTabbed(sender: UITapGestureRecognizer ) {
            if(tipShowing){
                finishWalkthrough()
                timer.invalidate()
                tipShowing = false
                
            }
            let tag = sender.view?.accessibilityIdentifier
            let indexPathArr = tag!.components(separatedBy: ",")
            let row = Int(indexPathArr[0])
            let section = Int(indexPathArr[1])
            
            if let cell: ContactsTableViewCell = tableView?.cellForRow(at: IndexPath(row: row!, section: section!)) as? ContactsTableViewCell {
                cell.imgDial.image = UIImage(named: "dial_pressed")
                DispatchQueue.main.asyncAfter(deadline: .now()+0.10 ) {
                    cell.imgDial.image = UIImage(named: "dial")
                    
                }        }
            
            let nameKey = contactsSectionTitles[section!]
            if let nameValues = contactsDictionary[nameKey] {
                var phone = nameValues[row!].phoneNumber
                phone = phone.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                dialNumber(number: phone)
                
            }
            
        }
        
        func dialNumber(number : String) {
            if(tipShowing){
                finishWalkthrough()
                timer.invalidate()
                tipShowing = false
                
            }
            
            
            if let url = URL(string: "tel://\(number)"),
               UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            if(contactsSectionTitles[section] == ""){
                return "#"
            }else{
                return contactsSectionTitles[section]
            }
        }
        
        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return contactsSectionTitles
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
            
            let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
            if(contactsSectionTitles[section] == ""){
                headerView.lblLetter.text = "#"
            }else{
                headerView.lblLetter.text = contactsSectionTitles[section]
            }
            return headerView
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            contactsDictionary = [String: [ContactItem]]()
            if searchBar.text == nil || searchBar.text == ""{
                resetContacts()
                
            }else{
                for contact in listContacts {
                    if((contact.firstName+" "+contact.middleName+" "+contact.familyName + " " + contact.phoneNumber).lowercased().contains(searchBar.text!.lowercased())){
                        let nameKey = String(contact.firstName.prefix(1))
                        if var nameValues = contactsDictionary[nameKey] {
                            nameValues.append(contact)
                            contactsDictionary[nameKey] = nameValues
                        } else {
                            contactsDictionary[nameKey] = [contact]
                        }
                        
                    }
                }
                
                contactsSectionTitles = [String](contactsDictionary.keys)
                
                contactsSectionTitles = contactsSectionTitles.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending  })
                for i in 0 ..< contactsSectionTitles.count {
                    if(contactsSectionTitles[i] == "#"){
                        contactsSectionTitles.remove(at: i)
                        contactsSectionTitles.append("#")
                        
                        break
                    }
                }
                
                self.collectionView?.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                //tableView.reloadData()
                if(contactsDictionary.count == 0){
                    collectionView.isHidden = true
                    //tableView.isHidden = true
                    lblNotFound.text = NSLocalizedString("no_result_for", comment: "") + " \"" + searchBar.text! + "\""
                    imgNotFound.image = UIImage(named: "not_found_search")
                    not_found_view.isHidden = false
                }else{
                    collectionView.isHidden = false
                    //tableView.isHidden = false
                    lblNotFound.text = NSLocalizedString("no_contact_found", comment: "")
                    imgNotFound.image = UIImage(named: "not_found_contact")
                    not_found_view.isHidden = true
                }
                
            }
            
        }
        
        func resetContacts(){
            print("1984 resetContacts")
            for contact in listContacts {
                let nameKey = String(contact.firstName.prefix(1))
                if var nameValues = contactsDictionary[nameKey] {
                    nameValues.append(contact)
                    contactsDictionary[nameKey] = nameValues
                } else {
                    contactsDictionary[nameKey] = [contact]
                }
            }
            
            contactsSectionTitles = [String](contactsDictionary.keys)
            
            contactsSectionTitles = contactsSectionTitles.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending  })
            for i in 0 ..< contactsSectionTitles.count {
                if(contactsSectionTitles[i] == "#"){
                    contactsSectionTitles.remove(at: i)
                    contactsSectionTitles.append("#")
                    
                    break
                }
            }
            
            self.collectionView?.reloadData()
            //tableView.reloadData()
            if(contactsDictionary.count == 0){
                //tableView.isHidden = false
                collectionView.isHidden = false
                lblNotFound.text = NSLocalizedString("no_result_for", comment: "")
                imgNotFound.image = UIImage(named: "not_found_search")
                not_found_view.isHidden = true
            }else{
                //tableView.isHidden = false
                collectionView.isHidden = false
                lblNotFound.text = NSLocalizedString("no_contact_found", comment: "")
                imgNotFound.image = UIImage(named: "not_found_contact")
                not_found_view.isHidden = true
            }
        }

        @objc func resetList(_ notification: Notification){
            print("1984 resetList")
            if searchBar.text != nil && searchBar.text != ""{
                searchBar.text = ""
                searchBar.resignFirstResponder()
                for contact in listContacts {
                    let nameKey = String(contact.firstName.prefix(1))
                    if var nameValues = contactsDictionary[nameKey] {
                        nameValues.append(contact)
                        contactsDictionary[nameKey] = nameValues
                    } else {
                        contactsDictionary[nameKey] = [contact]
                    }
                    
                }
                
                contactsSectionTitles = [String](contactsDictionary.keys)
                
                contactsSectionTitles = contactsSectionTitles.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending  })
                for i in 0 ..< contactsSectionTitles.count {
                    if(contactsSectionTitles[i] == "#"){
                        contactsSectionTitles.remove(at: i)
                        contactsSectionTitles.append("#")
                        
                        break
                    }
                }
                
                self.collectionView?.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                //tableView.reloadData()
                if(contactsDictionary.count == 0){
                    //tableView.isHidden = false
                    collectionView.isHidden = false
                    lblNotFound.text = NSLocalizedString("no_result_for", comment: "")
                    imgNotFound.image = UIImage(named: "not_found_search")
                    not_found_view.isHidden = true
                }else{
                    // tableView.isHidden = false
                    collectionView.isHidden = false
                    lblNotFound.text = NSLocalizedString("no_contact_found", comment: "")
                    imgNotFound.image = UIImage(named: "not_found_contact")
                    not_found_view.isHidden = true
                }
                
            }
            
            
        }
        
       /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if(tipShowing){
                finishWalkthrough()
                timer.invalidate()
                tipShowing = false
                
            }
            searchBar.resignFirstResponder()
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcDetails") as? DetailsViewController {
                if let navigator = self.navigationController {
                    let nameKey = contactsSectionTitles[indexPath.section]
                    if let nameValues = contactsDictionary[nameKey] {
                        if(nameValues[indexPath.row].firstName + " " + nameValues[indexPath.row].middleName + " " + nameValues[indexPath.row].familyName == "#  "){
                            viewController.title =  nameValues[indexPath.row].phoneNumber
                        }else{
                            viewController.title =  nameValues[indexPath.row].firstName + " " + nameValues[indexPath.row].middleName + " " + nameValues[indexPath.row].familyName
                        }
                        
                        viewController.contact = nameValues[indexPath.row]
                        
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
        }*/
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            if(tipShowing){
                finishWalkthrough()
                timer.invalidate()
                tipShowing = false
                
            }
            searchBar.resignFirstResponder()
            
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcDetails") as? DetailsViewController {
                if let navigator = self.navigationController {
                    let nameKey = contactsSectionTitles[indexPath.section]
                    if let nameValues = contactsDictionary[nameKey] {
                        if(nameValues[indexPath.row].firstName + " " + nameValues[indexPath.row].middleName + " " + nameValues[indexPath.row].familyName == "#  "){
                            viewController.title =  nameValues[indexPath.row].phoneNumber
                        }else{
                            viewController.title =  nameValues[indexPath.row].firstName + " " + nameValues[indexPath.row].middleName + " " + nameValues[indexPath.row].familyName
                        }
                        
                        viewController.contact = nameValues[indexPath.row]
                        
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
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.shadowImage = UIImage()
            
            self.navigationController?.hidesBarsOnSwipe = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.tintColor = UIColor(red: 42/255, green: 42/255, blue: 41/255, alpha: 1)
        }
        
        @objc func reloadDataContacts(_ notification: Notification) {
            print("1984 reloadDataContacts")
            var favoriteList = [ContactItem]()
            if(self.defaults.object(forKey: "favoriteList") != nil){
                
                let decoded  = defaults.object(forKey: "favoriteList") as! Data
                favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
                
            }
            
            for contact in listContacts {
                var i = false
                for contactFav in favoriteList {
                    if(contact.id == contactFav.id){
                        contact.isFavorite = "true"
                        i = true
                    }
                }
                if(i == false){
                    contact.isFavorite = "false"
                }
            }
            
            if(listContacts.count > 1){
                searchBar.isUserInteractionEnabled = true
            }else{
                searchBar.isUserInteractionEnabled = false
            }
            
            self.collectionView?.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            //tableView.reloadData()
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
    
    extension ContactVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
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
            return contactsSectionTitles.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("188444 : " , contactsSectionTitles.count)
            // return contactsSectionTitles.count
            
            let nameKey = contactsSectionTitles[section]
            if let nameValues = contactsDictionary[nameKey] {
                return nameValues.count
            }
            
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? ContactCollectionCell {
                
                let contactsSectionTitle = contactsSectionTitles[indexPath.section]
                
                if let nameValues = contactsDictionary[contactsSectionTitle] {
                    cell.image.image = UIImage(named: "contactsBubbleBackground")
                    
                    let contactName = nameValues[indexPath.row].firstName+" "+nameValues[indexPath.row].middleName+" "+nameValues[indexPath.row].familyName
                    
                    if(contactName == "#  "){
                        cell.nameLabel.text = nameValues[indexPath.row].phoneNumber
                        
                    }else{
                        cell.nameLabel.text = nameValues[indexPath.row].firstName+" "+nameValues[indexPath.row].middleName+" "+nameValues[indexPath.row].familyName
                    }
                    
                    if(nameValues[indexPath.row].img != nil){
                        cell.image.image = UIImage(data: nameValues[indexPath.row].img!)
                    } else {
                        cell.image.image = UIImage(named: "users")!
                    }
                }
                
                return cell
                
            } else {
                return UICollectionViewCell()
            }
        }
    }
