//
//  DetailsViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 31.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Contacts
import FBAudienceNetwork
import GoogleMobileAds
import PopupDialog

class DetailsViewController: TabmanViewController, PageboyViewControllerDataSource, FBAdViewDelegate, GADBannerViewDelegate, FBInterstitialAdDelegate, GADInterstitialDelegate {
    
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    private var viewControllers = [UIViewController]()
    let defaults = UserDefaults.standard
    var contact: ContactItem? = ContactItem(id: "0", firstName: "", middleName: "", familyName: "", phoneNumber: "", isFavorite: "false", img: nil)
    var favoriteList: [ContactItem] = [ContactItem]()
    var detailTabList: [String] = ["facebook", "instagram", "twitter", "gmail", "customtab1",  "customtab2", "customtab3", "notes"]
    var userNames: UsernamesItem? = nil
    
    @IBOutlet weak var userInfoView: UIStackView!
    @IBOutlet var tabBar: UIView!
    @IBOutlet var messengerBar: UIView!
    
    @IBOutlet var btnPopupInfo: UIBarButtonItem!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    @IBOutlet var btnCall: UIBarButtonItem!
    var barItemDizi: [TabmanBar.Item] = []
    var highlightedColon = ""
    
    @IBOutlet var btnWhatsapp: UIImageView!
    @IBOutlet var btnMessenger: UIImageView!
    @IBOutlet var btnViber: UIImageView!
    @IBOutlet var btnTelegram: UIImageView!
    @IBOutlet var btnSms: UIImageView!
    
    @IBOutlet var viewWhatsapp: UIView!
    @IBOutlet var viewMessenger: UIView!
    @IBOutlet var viewViber: UIView!
    @IBOutlet var viewTelegram: UIView!
    @IBOutlet var viewSms: UIView!
    
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    
    @IBOutlet var cizgiWhatsapp: UIView!
    @IBOutlet var cizgiMessenger: UIView!
    @IBOutlet var cizgiViber: UIView!
    @IBOutlet var cizgiTelegram: UIView!
    var noMessengerItem = false
    @IBOutlet var adView: UIView!
    @IBOutlet weak var adViewContainer: UIView!
    var bannerViewFacebook: FBAdView!
    var bannerViewAdmob: GADBannerView!
    let interstitialFBAD: FBInterstitialAd = FBInterstitialAd(placementID: "1261484220642800_1261488100642412")
    var interstitialAdmob: GADInterstitial! = GADInterstitial(adUnitID: "ca-app-pub-8886884732302136/5905076024")
    @IBOutlet weak var snackBar: UIView!
    @IBOutlet weak var snackBarText: UILabel!
    @IBOutlet weak var btnProfilePic: UIBarButtonItem!
    @IBOutlet weak var imgProfilePic: UIImageView!

    @IBOutlet weak var viewAddTab: UIView!
    @IBOutlet weak var btnAddTab: UIButton!
    
    var customTab1Name = "";
    var customTab2Name = "";
    var customTab3Name = "";
    var customTab1Url = "";
    var customTab2Url = "";
    var customTab3Url = "";
    @IBOutlet weak var widhtBtnAddView: NSLayoutConstraint!
    var currentCustomTabUrl = "";
    var customWalkthroughView: CustomWalkthroughView? { return walkthroughView as? CustomWalkthroughView }
    @IBOutlet weak var tipView: UIView!
    var tipShowing = false;
    var tipShowed = false;
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white

        navigationController?.navigationBar.isTranslucent = true
    
        self.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar(_:)), name: Notification.Name(rawValue: "hideTabBar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar(_:)), name: Notification.Name(rawValue: "showTabBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage(_:)), name: Notification.Name(rawValue: "refreshPage"), object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(openPopup(_:)), name: Notification.Name(rawValue: "openPopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openEditTabPopup(_:)), name: Notification.Name(rawValue: "openEditTabPopup"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(viewAddTabHide(_:)), name: Notification.Name(rawValue: "viewAddTabHide"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(viewAddTabShow(_:)), name: Notification.Name(rawValue: "viewAddTabShow"), object: nil)

         userNames = DbUtil.sharedInstance.getUserNames(contactId: contact!.id)
        
        if(!(userNames?.customTab3Name?.elementsEqual("") ?? true)){
            widhtBtnAddView.constant = 0
        }
        
        nameLabel.text = contact!.firstName + " " + contact!.middleName
        
        if(contact!.img != nil){

            profileImage.image = UIImage(data: contact!.img!)
            /*profileImage.layer.masksToBounds = false
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true*/

            imgProfilePic.image = UIImage(data: contact!.img!)
            imgProfilePic.layer.masksToBounds = false
            imgProfilePic.layer.cornerRadius = imgProfilePic.frame.height/2
            imgProfilePic.clipsToBounds = true
            
            let tapGesture1 = UITapGestureRecognizer (target: self, action: #selector(clickPic))
            
            tapGesture1.numberOfTapsRequired = 1
            tapGesture1.numberOfTouchesRequired = 1
            imgProfilePic.isUserInteractionEnabled = true
            imgProfilePic.addGestureRecognizer(tapGesture1)
            
            profileImage.isUserInteractionEnabled = true
            profileImage.addGestureRecognizer(tapGesture1)
            
            
        }else{
            btnProfilePic = nil
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
    
        initializeViewControllers()
        dataSource = self
        // configure the bar
    
        bar.appearance = TabmanBar.Appearance({ (appearance) in
            bar.style = .scrollingButtonBar

            appearance.state.selectedColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            appearance.text.font = .systemFont(ofSize: 17.0)
            appearance.indicator.color = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            appearance.bottomSeparator.height = SeparatorHeight.medium
            appearance.bottomSeparator.color = UIColor.groupTableViewBackground
            appearance.indicator.useRoundedCorners = true
            appearance.interaction.isScrollEnabled = true
            appearance.style.background = .solid(color: UIColor.white)
        })
        if(defaults.object(forKey: "favoriteList") != nil){
            let decoded  = defaults.object(forKey: "favoriteList") as! Data
            favoriteList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ContactItem]
        }
        if(contact?.isFavorite == "true"){
            btnFavorite.image = UIImage(named: "star_fill")
            btnFavorite.tintColor = UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 64.0/255.0, alpha: 1.0)

        }else{
            btnFavorite.image = UIImage(named: "star")
            btnFavorite.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        self.embedBar(in: tabBar)
        
        messengerBar.layer.shadowOffset = CGSize(width: 0, height: 3)
       // messengerBar.layer.shadowOpacity = 0.3
        //messengerBar.layer.shadowRadius = 3.0
        messengerBar.layer.shadowColor = UIColor.black.cgColor

        bannerViewFacebook = FBAdView(placementID: "1261484220642800_1261491547308734", adSize: kFBAdSize320x50, rootViewController: self)
        bannerViewFacebook.delegate = self
        
        adView.addSubview(bannerViewFacebook)
        bannerViewFacebook.frame.size = CGSize(width: view.frame.size.width, height: 50)
            
            bannerViewFacebook.loadAd()
            
            controlInterstitial()
      
        let sessionCount = defaults.integer(forKey: "sessionCount")
        let hiddenRateDialog = defaults.bool(forKey: "hiddenRateDialog")

        if(sessionCount > 29 && !hiddenRateDialog){
            performSegue(withIdentifier: "seguePopupRate", sender: nil)
            defaults.set(true, forKey: "hiddenRateDialog")
        }
        
        self.tipShowed = self.defaults.bool(forKey: "tipShowed")

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if(sessionCount < 2 && !self.tipShowed){
                     self.showTip()
             }
         }
    }
    
    func showTip() {
        tipShowing = true
        tipShowed = true
            self.defaults.set(tipShowed, forKey: "tipShowed")
            self.defaults.synchronize()
        startWalkthrough(CustomWalkthroughView())
        walkthroughView?.cutHolesForViewDescriptors([ViewDescriptor(view: tipView, extraPaddingLeft: 30, extraPaddingTop: 48, extraPaddingRight: 0, extraPaddingBottom: 0, cornerRadius: 100)])
                          
               customWalkthroughView?.helpLabel.isHidden = false
                      customWalkthroughView?.helpLabel.text = NSLocalizedString("detail_guide_text", comment: "")
               customWalkthroughView?.helpLabel.frame = CGRect(x: 20, y: self.view.center.y, width: self.view.frame.width-40, height: 80)
        
           let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
           customWalkthroughView!.addGestureRecognizer(gesture)
       }
      
       @objc func checkAction(sender : UITapGestureRecognizer) {
           tipShowing = false

           finishWalkthrough()
       }
    
    @objc func clickPic(sender: UITapGestureRecognizer ) {
        performSegue(withIdentifier: "seguePopup", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        let bottom = CGAffineTransform(translationX: 0, y: 80)
        self.snackBar.transform = bottom
    }
    // FB GEÇİŞ REKLAMI
    func loadInterstitialAd() {
        interstitialFBAD.delegate = self
        interstitialFBAD.load()
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
             DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.interstitialFBAD.show(fromRootViewController: self)
        
                print("popup fb")
        }
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("failed facebook geçiş")
        let request = GADRequest()
        interstitialAdmob.delegate = self
        interstitialAdmob.load(request)
    }
    
    // FACEBOOK ADS FUNCTIONS
    func adViewDidLoad(_ adView: FBAdView) {
        print("yüklendi facebook reklam")
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print("hata facebook reklam: " + error.localizedDescription)
        
        self.bannerViewAdmob = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerViewAdmob.delegate = self
        self.bannerViewAdmob.adUnitID = "ca-app-pub-8886884732302136/4947217578"
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
        
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerViewAdmob)
     
        
    }
    
    // ADMOB GEÇİŞ
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
             DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
        self.interstitialAdmob.present(fromRootViewController: self)
            
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeBottomHeight"), object: nil)

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
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
        
    }
    

    private func initializeViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        barItemDizi = []
       
        if(userNames?.visibilityFbUsername == "0"){
            let index =  detailTabList.firstIndex(of: "facebook")
            
            detailTabList.remove(at: index!)
            
        }
        if(userNames?.visibilityInstagramUsername == "0"){
                 let index =  detailTabList.firstIndex(of: "instagram")
                 
                 detailTabList.remove(at: index!)
                 
             }
        if(userNames?.visibilityTwitterUsername == "0"){
            let index =  detailTabList.firstIndex(of: "twitter")
            
            detailTabList.remove(at: index!)
            
        }
        if(userNames?.visibilityGmailUsername == "0"){
             let index =  detailTabList.firstIndex(of: "gmail")
             
             detailTabList.remove(at: index!)
             
         }
        if(userNames?.visibilityNotes == "0"){
            let index =  detailTabList.firstIndex(of: "notes")
            
            detailTabList.remove(at: index!)
            
        }
        
        if(userNames?.customTab1Url == "" || userNames?.customTab1Url == nil){
                      let index =  detailTabList.firstIndex(of: "customtab1")
                     
                      detailTabList.remove(at: index!)
                      
        }
        if(userNames?.customTab2Url == "" || userNames?.customTab2Url == nil){
                        let index =  detailTabList.firstIndex(of: "customtab2")
                       
                        detailTabList.remove(at: index!)
                        
           }
        if(userNames?.customTab3Url == "" || userNames?.customTab3Url == nil){
                        let index =  detailTabList.firstIndex(of: "customtab3")
                       
                        detailTabList.remove(at: index!)
                        
           }


        for tab in detailTabList{
            if(tab == "facebook"){
                let vcFacebook = storyboard.instantiateViewController(withIdentifier: "vcFacebook") as! FacebookViewController
                vcFacebook.url = "https://m.facebook.com/"
                vcFacebook.userName = userNames?.fbUsername ?? ""
                
                barItemDizi.append(Item(title: NSLocalizedString("facebook", comment: "")))
                viewControllers.append(vcFacebook)
                vcFacebook.loadViewIfNeeded()
            }else if(tab == "instagram"){
                let vcInstagram = storyboard.instantiateViewController(withIdentifier: "vcInstagram") as! InstagramViewController
                vcInstagram.url = "https://www.instagram.com/"
                vcInstagram.userName = userNames?.instagramUsername ?? ""
                
                barItemDizi.append(Item(title: NSLocalizedString("instagram", comment: "")))
                viewControllers.append(vcInstagram)
                vcInstagram.loadViewIfNeeded()
            }else if(tab == "twitter"){
                let vcTwitter = storyboard.instantiateViewController(withIdentifier: "vcTwitter") as! TwitterViewController
                 vcTwitter.url = "https://mobile.twitter.com/"
                 vcTwitter.userName = userNames?.twitterUsername ?? ""
                
                barItemDizi.append(Item(title: NSLocalizedString("twitter", comment: "")))
                viewControllers.append(vcTwitter)
                vcTwitter.loadViewIfNeeded()
            }else if(tab == "gmail"){
                let vcGmail = storyboard.instantiateViewController(withIdentifier: "vcGmail") as! GmailViewController
                 vcGmail.url = "https://mail.google.com/mail/mu/mp/37/#tl/search/"
                vcGmail.username = userNames?.gmailUsername ?? ""
                
                barItemDizi.append(Item(title: NSLocalizedString("gmail", comment: "")))
                viewControllers.append(vcGmail)
                vcGmail.loadViewIfNeeded()
            }
            else if(tab == "notes"){
                let vcNotes = storyboard.instantiateViewController(withIdentifier: "vcNotes") as! Notes
                vcNotes.contactID = contact!.id
                barItemDizi.append(Item(title: NSLocalizedString("notes", comment: "")))
                viewControllers.append(vcNotes)
                vcNotes.loadViewIfNeeded()
            }else if(tab == "customtab1"){
                let vcCustom = storyboard.instantiateViewController(withIdentifier: "vcCustom") as! CustomWebviewController
                vcCustom.url = userNames!.customTab1Url!
                barItemDizi.append(Item(title: userNames!.customTab1Name!))
                viewControllers.append(vcCustom)
                vcCustom.loadViewIfNeeded()
            }else if(tab == "customtab2"){
                let vcCustom = storyboard.instantiateViewController(withIdentifier: "vcCustom") as! CustomWebviewController
                vcCustom.url = userNames!.customTab2Url!
                barItemDizi.append(Item(title: userNames!.customTab2Name!))
                viewControllers.append(vcCustom)
                vcCustom.loadViewIfNeeded()
            }else if(tab == "customtab3"){
                let vcCustom = storyboard.instantiateViewController(withIdentifier: "vcCustom") as! CustomWebviewController
                vcCustom.url = userNames!.customTab3Url!
                barItemDizi.append(Item(title: userNames!.customTab3Name!))
                viewControllers.append(vcCustom)
                vcCustom.loadViewIfNeeded()
            }

            
        }
  
            self.bar.items = barItemDizi
        self.viewControllers = viewControllers

        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
        hideMessenger = defaults.bool(forKey: "hideMessenger")
        hideViber = defaults.bool(forKey: "hideViber")
        hideTelegram = defaults.bool(forKey: "hideTelegram")
        hideSms = defaults.bool(forKey: "hideSms")
 
        
        if(hideWhatsapp){
            viewWhatsapp.isHidden = true
            cizgiWhatsapp.isHidden = true
        }
        
        if(hideMessenger){
            viewMessenger.isHidden = true
            cizgiWhatsapp.isHidden = true

        }
        
        if(hideViber){
            viewViber.isHidden = true
            cizgiMessenger.isHidden = true

        }
        
        if(hideTelegram){
            viewTelegram.isHidden = true
            cizgiViber.isHidden = true

        }
        
        if(hideSms){
            viewSms.isHidden = true
            cizgiTelegram.isHidden = true

        }
        
        if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
           messengerBar.isHidden = true
           noMessengerItem = true
        }
        
        let tapGestureRecognizerWhatsapp = UITapGestureRecognizer(target: self, action: #selector(imageTappedWhatsapp(tapGestureRecognizer:)))
        viewWhatsapp.isUserInteractionEnabled = true
        viewWhatsapp.addGestureRecognizer(tapGestureRecognizerWhatsapp)
        
        let tapGestureRecognizerMessenger = UITapGestureRecognizer(target: self, action: #selector(imageTappedMessenger(tapGestureRecognizer:)))
        
        viewMessenger.isUserInteractionEnabled = true
        viewMessenger.addGestureRecognizer(tapGestureRecognizerMessenger)
        
        let tapGestureRecognizerViber = UITapGestureRecognizer(target: self, action: #selector(imageTappedViber(tapGestureRecognizer:)))
        
        viewViber.isUserInteractionEnabled = true
        viewViber.addGestureRecognizer(tapGestureRecognizerViber)
        
        let tapGestureRecognizerTelegram = UITapGestureRecognizer(target: self, action: #selector(imageTappedTelegram(tapGestureRecognizer:)))
        
        viewTelegram.isUserInteractionEnabled = true
        viewTelegram.addGestureRecognizer(tapGestureRecognizerTelegram)
        
        let tapGestureRecognizerSms = UITapGestureRecognizer(target: self, action: #selector(imageTappedSms(tapGestureRecognizer:)))
        viewSms.isUserInteractionEnabled = true
        viewSms.addGestureRecognizer(tapGestureRecognizerSms)
        
        let tapGestureRecognizerAddTab = UITapGestureRecognizer(target: self, action: #selector(tappedBtnAdd(tapGestureRecognizer:)))
        viewAddTab.isUserInteractionEnabled = true
        viewAddTab.addGestureRecognizer(tapGestureRecognizerAddTab)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func snackBar(title:String, long:Bool){
        snackBarText.text = title
        var duration = 1.2
        if(long == true){
            duration = 2.0
        }
        let bottom = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
            // Add the transformation in this block
            // self.container is your view that you want to animate
            self.snackBar.transform = bottom
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+duration ) {
            
            let hide = CGAffineTransform(translationX: 0, y: 80)
            
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations: {
                // Add the transformation in this block
                // self.container is your view that you want to animate
                self.snackBar.transform = hide
            }, completion: nil)
        }
    }
    
    @IBAction func btnFavorite(_ sender: Any) {
       
        if(btnFavorite.image == UIImage(named: "star_fill")){
            for i in 0..<self.favoriteList.count {
                if(favoriteList[i].id == contact?.id){
                    contact?.isFavorite = "false"
                    favoriteList.remove(at: i)
                    btnFavorite.image = UIImage(named: "star")
                    btnFavorite.tintColor = UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    snackBar(title: NSLocalizedString("removed_favorites", comment: ""), long: false)

                    break;

                }
                
            }

        }else{
            var add = true
            for i in 0..<favoriteList.count {
                if(favoriteList[i].id == contact?.id){
                    add = false
                }
            
            }
            
            if(add){
                contact?.isFavorite = "true"
                favoriteList.append(contact!)
                btnFavorite.image = UIImage(named: "star_fill")
                btnFavorite.tintColor = UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 64.0/255.0, alpha: 1.0)
                snackBar(title: NSLocalizedString("added_favorites", comment: ""), long: false)

                }else{
                    contact?.isFavorite = "true"
                    btnFavorite.image = UIImage(named: "star_fill")
                    btnFavorite.tintColor = UIColor(red: 255.0/255.0, green: 206.0/255.0, blue: 64.0/255.0, alpha: 1.0)
                    snackBar(title: NSLocalizedString("added_favorites", comment: ""), long: false)
                    
            }
        }

        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteList)
        defaults.set(encodedData, forKey: "favoriteList")
        defaults.synchronize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadDataContacts"), object: nil)
    }
    
    @objc func hideTabBar(_ notification: Notification) {
        self.viewAddTab.isHidden = true
        self.tabBar.isHidden = true
        self.messengerBar.isHidden = true
        self.userInfoView.isHidden = true
    }
    
    @objc func showTabBar(_ notification: Notification) {
        self.viewAddTab.isHidden = false
        self.tabBar.isHidden = false
        self.userInfoView.isHidden = false
        
        if(!noMessengerItem){
          self.messengerBar.isHidden = false
        }
    }
    
    @objc func refreshPage(_ notification: Notification) {
    
            
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
            defaults.set(detailTabList, forKey: "detailTabList")
            defaults.synchronize()
        }
        
        userNames = DbUtil.sharedInstance.getUserNames(contactId: contact!.id)

        initializeViewControllers()
        self.reloadPages()

        if let tabName = notification.userInfo?["tabName"] as? String {
            for i in 0..<self.bar.items!.count {
                if(self.bar.items![i].title! == tabName){
                    self.scrollToPage(.at(index: i), animated: false)
                 }
            }
        }

    }
    
  
    @objc func openPopup(_ notification: Notification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let colon = dict["colon"] as? String{
                highlightedColon = colon
            }
        }
        
        performSegue(withIdentifier: "seguePopup", sender: nil)

        
    }
    
    @objc func openEditTabPopup(_ notification: Notification) {

         if let dict = notification.userInfo as NSDictionary? {
             if let url = dict["url"] as? String{
                 currentCustomTabUrl = url
             }
         }
         
         performSegue(withIdentifier: "seguePopupAddTab", sender: nil)

         
     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
 if segue.identifier == "seguePopup" {
    if(tipShowing){
           finishWalkthrough()
           tipShowing = false

       }
        guard let popupViewController = segue.destination as? PopupViewController else { return }
        popupViewController.customBlurEffectStyle = UIBlurEffect.Style.regular
        popupViewController.customAnimationDuration = TimeInterval(0.5)
        popupViewController.customInitialScaleAmmount = CGFloat(Double(0.5))
        popupViewController.contact = contact
        popupViewController.highlightedColon = highlightedColon
        let cIndex = Int(self.currentIndex!.description)
        var currentTab = ""

        for i in 0..<self.bar.items!.count {
            if(i == cIndex){
               currentTab = self.bar.items![i].title!
             }
        }
        popupViewController.lastTab = currentTab

        highlightedColon = ""
 }else if(segue.identifier == "seguePopupAddTab"){
         guard let popupViewController = segue.destination as? AddTabPopup else { return }
                popupViewController.customBlurEffectStyle = UIBlurEffect.Style.regular
                popupViewController.customAnimationDuration = TimeInterval(0.5)
                popupViewController.customInitialScaleAmmount = CGFloat(Double(0.5))
                popupViewController.contactID = contact!.id
 
             if(!currentCustomTabUrl.elementsEqual("")){
                 if(userNames != nil){
                     if((userNames?.customTab1Url?.elementsEqual(currentCustomTabUrl))!){
                         popupViewController.tabNumber = 1
                        currentCustomTabUrl = ""
                         return
                     }else if((userNames?.customTab2Url?.elementsEqual(currentCustomTabUrl))!){
                         popupViewController.tabNumber = 2
                        currentCustomTabUrl = ""
                         return
                     }else if((userNames?.customTab3Url?.elementsEqual(currentCustomTabUrl))!){
                         popupViewController.tabNumber = 3
                        currentCustomTabUrl = ""
                         return
                     }
                 }
             }
                 popupViewController.tabNumber = 0

            

     }else if segue.identifier == "seguePopupRate" {
                 guard let popupViewController = segue.destination as? RatePopup else { return }
                 popupViewController.customBlurEffectStyle = UIBlurEffect.Style.regular
                 popupViewController.customAnimationDuration = TimeInterval(0.5)
                 popupViewController.customInitialScaleAmmount = CGFloat(Double(0.5))

              }
    }

    @objc func imageTappedWhatsapp(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        btnWhatsapp.image = UIImage(named: "whatsapp_pressed")

        DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
            self.btnWhatsapp.image = UIImage(named: "whatsapp")
        }

            if(contact?.phoneNumber != nil){
                if(contact!.phoneNumber.count > 2){
            let urlWhats = "whatsapp://send?phone=" + contact!.phoneNumber
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }
                    else {
                       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)]

                        let alert = UIAlertController(title: NSLocalizedString("whatsapp_not_installed", comment: ""), message: NSLocalizedString("do_you_want_to_get", comment: ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: { action in
                           
                            
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                           
                        }))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { action in
                           
                            
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                       
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id310633997"),
                                UIApplication.shared.canOpenURL(url)
                            {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            
                        }))
                        
                        self.present(alert, animated: true)
                     
                    
                    }
                }
            }
                }
                
            }
       
        
    }
    
    @objc func imageTappedMessenger(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnMessenger.image = UIImage(named: "messenger_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
            self.btnMessenger.image = UIImage(named: "messenger")
            
        }
                    let urlWhats = "fb-messenger://"
                    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                        if let whatsappURL = URL(string: urlString) {
                   if UIApplication.shared.canOpenURL(whatsappURL){
                    if(userNames?.fbUsername != nil){
                        if(userNames!.fbUsername != ""){
                    if let urlFromStr = URL(string: "https://m.me/" + userNames!.fbUsername!)  {
                        
                    if UIApplication.shared.canOpenURL(urlFromStr) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(urlFromStr, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(urlFromStr)
                        }
                      }
                     }
                        }else{
                            highlightedColon = "fb"
                            performSegue(withIdentifier: "seguePopup", sender: nil)
                        }
                        }else{
                            highlightedColon = "fb"
                            performSegue(withIdentifier: "seguePopup", sender: nil)
                        }
                    }else{
                        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)]
                        
                        let alert = UIAlertController(title: NSLocalizedString("messenger_not_installed", comment: ""), message: NSLocalizedString("do_you_want_to_get", comment: ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: { action in
                            
                            
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                            
                        }))
                        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { action in
                            
                            
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                            
                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id454638411"),
                                UIApplication.shared.canOpenURL(url)
                            {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            
                        }))
                        
                        self.present(alert, animated: true)
                    }
                }
                
            }
    }
    
    
    @objc func imageTappedViber(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnViber.image = UIImage(named: "viber_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
            self.btnViber.image = UIImage(named: "viber")
        }
        
        if(contact?.phoneNumber != nil){
            if(contact!.phoneNumber.count > 2){
                let urlWhats = "viber://contact?number=" + contact!.phoneNumber
                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                    if let viberURL = URL(string: urlString) {
                        if UIApplication.shared.canOpenURL(viberURL){
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(viberURL, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(viberURL)
                            }
                        }
                        else {
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)]
                            
                            let alert = UIAlertController(title: NSLocalizedString("viber_not_installed", comment: ""), message: NSLocalizedString("do_you_want_to_get", comment: ""), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: { action in
                                
                                
                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                                
                            }))
                            alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { action in
                                
                                
                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                                
                                if let url = URL(string: "itms-apps://itunes.apple.com/app/id382617920"),
                                    UIApplication.shared.canOpenURL(url)
                                {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                                
                            }))
                            
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func imageTappedTelegram(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnTelegram.image = UIImage(named: "telegram_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
            self.btnTelegram.image = UIImage(named: "telegram")
        }
        
        if(contact?.phoneNumber != nil){
            if(contact!.phoneNumber.count > 2){
                let urlWhats = "tg://msg?text=Foo&to=" + contact!.phoneNumber
                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                    if let telegramURL = URL(string: urlString) {
                        if UIApplication.shared.canOpenURL(telegramURL){
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(telegramURL, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(telegramURL)
                            }
                        }
                        else {
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)]
                            
                            let alert = UIAlertController(title: NSLocalizedString("telegram_not_installed", comment: ""), message: NSLocalizedString("do_you_want_to_get", comment: ""), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel, handler: { action in
                                
                                
                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                                
                            }))
                            alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { action in
                                
                                
                                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
                                
                                if let url = URL(string: "itms-apps://itunes.apple.com/app/id686449807"),
                                    UIApplication.shared.canOpenURL(url)
                                {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                                
                            }))
                            
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func imageTappedSms(tapGestureRecognizer: UITapGestureRecognizer)
    {
        btnSms.image = UIImage(named: "sms_pressed")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
            self.btnSms.image = UIImage(named: "sms")
            
        }
        if(contact?.phoneNumber != nil){
            if(contact!.phoneNumber.count > 2){
                var number = contact!.phoneNumber.replacingOccurrences(of: "-", with: "")
                number = number.replacingOccurrences(of: " ", with: "")
                number = number.replacingOccurrences(of: "(", with: "")
                number = number.replacingOccurrences(of: ")", with: "")
                
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(URL(string: "sms:" + number)!, options: [:], completionHandler: nil)
                            } else {
                                
                                UIApplication.shared.openURL(URL(string: "sms:" + number)!)
                            }
            }
        }
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
    
    @IBAction func btnCall(_ sender: Any) {
        var phone = contact!.phoneNumber.replacingOccurrences(of: " ", with: "")
         phone = phone.replacingOccurrences(of: "-", with: "")
        dialNumber(number: phone)
    }
    
    func controlInterstitial(){

       let sonTarih = defaults.object(forKey: "sonGecisReklamTarihi")
        if(sonTarih != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let formatedStartDate = dateFormatter.date(from: sonTarih as! String)
            let currentDate = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
            let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
            
            if(differenceOfDate.year! == 0){
                if(differenceOfDate.month! == 0 ){
                    if(differenceOfDate.day! == 0){
                        if(differenceOfDate.hour! == 0){
                            if(differenceOfDate.minute! >= 5){
                                loadInterstitialAd()
                                self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
                                self.defaults.synchronize()
                            }
                        }else{
                            loadInterstitialAd()
                            self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
                            self.defaults.synchronize()
                        }
                    }else{
                        loadInterstitialAd()
                        self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
                        self.defaults.synchronize()
                    }
                }else{
                    loadInterstitialAd()
                    self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
                    self.defaults.synchronize()
                }
            }else{
                loadInterstitialAd()
                self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
                self.defaults.synchronize()
            }
        }else{
            loadInterstitialAd()
            self.defaults.set(Date().description, forKey: "sonGecisReklamTarihi")
            self.defaults.synchronize()
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeTabs"), object: nil)
        }
    }
    
    @objc func tappedBtnAdd(tapGestureRecognizer: UITapGestureRecognizer)
    {
              btnAddTab.tintColor = UIColor(red: 222.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)

            DispatchQueue.main.asyncAfter(deadline: .now()+0.12 ) {
                self.btnAddTab.tintColor = UIColor.clear

            }
        currentCustomTabUrl = ""
        performSegue(withIdentifier: "seguePopupAddTab", sender: nil)

    }

    @objc func viewAddTabHide(_ notification: Notification)
    {
            widhtBtnAddView.constant = 0

    }
    
    @objc func viewAddTabShow(_ notification: Notification)
     {
         widhtBtnAddView.constant = 40

     }
}
