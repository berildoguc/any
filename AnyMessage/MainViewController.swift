//
//  MainViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 30.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import Contacts
import FBAudienceNetwork
import GoogleMobileAds

class MainViewController: UITabBarController, UITabBarControllerDelegate, UISearchBarDelegate, FBInterstitialAdDelegate, GADInterstitialDelegate /*, UNUserNotificationCenterDelegate */{
    var listContacts = [ContactItem]()
    let button = UIButton.init(type: .custom)
    let defaults = UserDefaults.standard
    var mainTabList: [String] = ["contacts", "favorites", "notes"]
    var interstitialFBAD: FBInterstitialAd = FBInterstitialAd(placementID: "1261484220642800_1261488100642412")
    var interstitialAdmob: GADInterstitial! = GADInterstitial(adUnitID: "ca-app-pub-8886884732302136/5905076024")
    var contactsTabID = 0
    var favoritesTabID = 1
    var allnotesTabID = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Medium", size: 11)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
       /*  let application = UIApplication.shared

           if #available(iOS 10.0, *){
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            }else{
                let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            */
        
        
        if(defaults.object(forKey: "mainTabList") != nil){
            mainTabList  = defaults.array(forKey: "mainTabList") as! [String]
            
        }else{
            mainTabList[0] = "contacts"
            mainTabList[1] = "favorites"
            mainTabList[2] = "notes"
            defaults.set(mainTabList, forKey: "mainTabList")
            defaults.synchronize()
            
        }
        navigationController?.navigationBar.shadowImage = UIImage()

         self.tabBarController?.delegate = self
         self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reOrderTab(_:)), name: Notification.Name(rawValue: "reOrderTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTabs(_:)), name: Notification.Name(rawValue: "changeTabs"), object: nil)
        interstitialFBAD.delegate = self

        let sessionCount = defaults.integer(forKey: "sessionCount")
        if(sessionCount < 31){
            defaults.set(sessionCount+1, forKey: "sessionCount")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(mainTabList[0] == "contacts"){
            
            if(mainTabList[1] == "favorites"){
                
                
                if let wVCs = self.viewControllers {
                 
                    self.viewControllers = [wVCs[contactsTabID ], wVCs[ favoritesTabID ], wVCs[ allnotesTabID ] ]
                  
                }
                self.tabBar.items?[0].title = NSLocalizedString("contacts", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("favorites", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("notes", comment: "")
                
                contactsTabID = 0
                favoritesTabID = 1
                allnotesTabID = 2
            }else{
                
                if let wVCs = self.viewControllers {
             
                    self.viewControllers = [wVCs[ contactsTabID ], wVCs[ allnotesTabID ], wVCs[ favoritesTabID ] ]
                 
                }
                self.tabBar.items?[0].title = NSLocalizedString("contacts", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("favorites", comment: "")
                contactsTabID = 0
                favoritesTabID = 2
                allnotesTabID = 1
            }
        }else if(mainTabList[0] == "favorites"){
            
            if(mainTabList[1] == "contacts"){
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ favoritesTabID ], wVCs[ contactsTabID ], wVCs[ allnotesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("favorites", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("contacts", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("notes", comment: "")
                contactsTabID = 1
                favoritesTabID = 0
                allnotesTabID = 2
            }else{
                
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ favoritesTabID ], wVCs[ allnotesTabID ], wVCs[ contactsTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("favorites", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("contacts", comment: "")
                contactsTabID = 2
                favoritesTabID = 0
                allnotesTabID = 1
            }
        }else if(mainTabList[0] == "notes"){
            
            if(mainTabList[1] == "contacts"){
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ allnotesTabID ], wVCs[ contactsTabID ], wVCs[ favoritesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[1].title = NSLocalizedString("contacts", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("favorites", comment: "")
                contactsTabID = 1
                favoritesTabID = 2
                allnotesTabID = 0
            }else{
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ allnotesTabID ], wVCs[ favoritesTabID ], wVCs[ contactsTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("notes", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("favorites", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("contacts", comment: "")
                contactsTabID = 2
                favoritesTabID = 1
                allnotesTabID = 0
            }
        }
        
        for i in 0..<self.viewControllers!.count {
            
            if((self.viewControllers![i] as! UINavigationController).viewControllers.first?.restorationIdentifier == "idContacts"){
                
                ((self.viewControllers?[i] as! UINavigationController).viewControllers.first as! ContactVC).listContacts = listContacts
                
            }else if((self.viewControllers![i] as! UINavigationController).viewControllers.first?.restorationIdentifier == "idAllNotes"){
                ((self.viewControllers?[i] as! UINavigationController).viewControllers.first as! AllNotes).listContacts = listContacts
                
            }
        }
        self.tabBar.selectedItem?.index(ofAccessibilityElement: 0)

    }
    @objc func reOrderTab(_ notification: Notification) {
    
        if(defaults.object(forKey: "mainTabList") != nil){
            mainTabList  = defaults.array(forKey: "mainTabList") as! [String]
            
        }else{
            mainTabList[0] = "contacts"
            mainTabList[1] = "favorites"
            mainTabList[2] = "botes"
            defaults.set(mainTabList, forKey: "mainTabList")
            defaults.synchronize()
            
        }
        if(mainTabList[0] == "contacts"){
            
            if(mainTabList[1] == "favorites"){
                
                
                if let wVCs = self.viewControllers {
                    
                    self.viewControllers = [wVCs[contactsTabID ], wVCs[ favoritesTabID ], wVCs[ allnotesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("contacts", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("favorites", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("notes", comment: "")
                
                contactsTabID = 0
                favoritesTabID = 1
                allnotesTabID = 2
            }else{
                
                if let wVCs = self.viewControllers {
                    
                    self.viewControllers = [wVCs[ contactsTabID ], wVCs[ allnotesTabID ], wVCs[ favoritesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("contacts", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("favorites", comment: "")
                contactsTabID = 0
                favoritesTabID = 2
                allnotesTabID = 1
            }
        }else if(mainTabList[0] == "favorites"){
            
            if(mainTabList[1] == "contacts"){
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ favoritesTabID ], wVCs[ contactsTabID ], wVCs[ allnotesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("favorites", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("contacts", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("notes", comment: "")
                contactsTabID = 1
                favoritesTabID = 0
                allnotesTabID = 2
            }else{
                
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ favoritesTabID ], wVCs[ allnotesTabID ], wVCs[ contactsTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("favorites", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("contacts", comment: "")
                contactsTabID = 2
                favoritesTabID = 0
                allnotesTabID = 1
            }
        }else if(mainTabList[0] == "notes"){
            
            if(mainTabList[1] == "contacts"){
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ allnotesTabID ], wVCs[ contactsTabID ], wVCs[ favoritesTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("notes", comment: "")
                self.tabBar.items?[1].title = NSLocalizedString("contacts", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("favorites", comment: "")
                contactsTabID = 1
                favoritesTabID = 2
                allnotesTabID = 0
            }else{
                
                if let wVCs = self.viewControllers {
                    self.viewControllers = [wVCs[ allnotesTabID ], wVCs[ favoritesTabID ], wVCs[ contactsTabID ] ]
                    
                }
                self.tabBar.items?[0].title = NSLocalizedString("notes", comment: "")
                
                self.tabBar.items?[1].title = NSLocalizedString("favorites", comment: "")
                self.tabBar.items?[2].title = NSLocalizedString("contacts", comment: "")
                contactsTabID = 2
                favoritesTabID = 1
                allnotesTabID = 0
            }
        }
        
        for i in 0..<self.viewControllers!.count {
            
            if((self.viewControllers![i] as! UINavigationController).viewControllers.first?.restorationIdentifier == "idContacts"){
                
                ((self.viewControllers?[i] as! UINavigationController).viewControllers.first as! ContactVC).listContacts = listContacts
                
            }else if((self.viewControllers![i] as! UINavigationController).viewControllers.first?.restorationIdentifier == "idAllNotes"){
                ((self.viewControllers?[i] as! UINavigationController).viewControllers.first as! AllNotes).listContacts = listContacts
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // FB GEÇİŞ REKLAMI
    func loadInterstitialAd() {
        interstitialFBAD = FBInterstitialAd(placementID: "1261484220642800_1261488100642412")
        interstitialFBAD.delegate = self

        interstitialFBAD.load()

    }
    
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            
            self.interstitialFBAD.show(fromRootViewController: self)

            let ilkIndex = self.selectedIndex
            if(ilkIndex == 0){
                self.selectedIndex = 1
                self.selectedIndex = 0
            }else if(ilkIndex == 1){
                self.selectedIndex = 0
                self.selectedIndex = 1
            }
        }
     
        
        print("popup")
        
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        print("failed facebook geçiş")
        let request = GADRequest()
        interstitialAdmob.delegate = self
        interstitialAdmob.load(request)
    }
    
    // ADMOB GEÇİŞ
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            
            self.interstitialAdmob.present(fromRootViewController: self)
 
            let ilkIndex = self.selectedIndex
            if(ilkIndex == 0){
                self.selectedIndex = 1
                self.selectedIndex = 0
            }else if(ilkIndex == 1){
                self.selectedIndex = 0
                self.selectedIndex = 1
            }
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
    
    
    func controlInterstitial(){
        print("controlInterstitial")

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
    
    @objc func changeTabs(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {

        let ilkIndex = self.selectedIndex
        if(ilkIndex == 0){
            self.selectedIndex = 1
            self.selectedIndex = 0
        }else if(ilkIndex == 1){
            self.selectedIndex = 0
            self.selectedIndex = 1
        }
        
            self.controlInterstitial()
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

                NotificationCenter.default.post(name: Notification.Name(rawValue: "resetList"), object: nil)
     
      }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return false }
        if viewController == viewControllers[selectedIndex] {
            if let nav = viewController as? UINavigationController {
                guard let topController = nav.viewControllers.last else { return true }

                if !topController.isScrolledToTop {
                    topController.scrollToTop()
                    return false
                } else {

                    nav.popViewController(animated: true)
                }
                return true
            }
        }
        
        return true
    }
    

}

extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: view)
    }
    
    var isScrolledToTop: Bool {
        if self is UITableViewController {
            return (self as! UITableViewController).tableView.contentOffset.y == 0
        }
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                return (scrollView.contentOffset.y == 0)
            }
        }
        return true
    }
    /*
    @objc(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        
        completionHandler()
    }
    
    @objc(userNotificationCenter:willPresentNotification:withCompletionHandler:) @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
 
 */
    
 
}
