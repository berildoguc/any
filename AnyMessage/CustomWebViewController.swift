//
//  FacebookViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 31.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import WebKit

class CustomWebviewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var stkLoading: UIStackView!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet var viewWarning: UIView!
    @IBOutlet var imgWarning: UIImageView!
    @IBOutlet var lblWarning: UILabel!
    @IBOutlet var btnWarning: UIButton!
    @IBOutlet weak var btnEditTab: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var btnBack: UIImageView!
    @IBOutlet var viewBackButton: UIView!
    @IBOutlet var backTopConstraint: NSLayoutConstraint!
    var url = ""
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    let defaults = UserDefaults.standard
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var refController:UIRefreshControl = UIRefreshControl()
    var isRefreshing = false
    @IBOutlet weak var bottomConstraintBtn: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            btnEditTab.layer.cornerRadius = 0.5 * btnEditTab.bounds.size.width

            btnEditTab.layer.shadowOpacity = 0.3
            btnEditTab.layer.shadowRadius = 3.0
            btnEditTab.layer.shadowColor = UIColor.black.cgColor
            btnEditTab.layer.masksToBounds = false
   
            btnEditTab.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btnWarning.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)

        lblWarning.text = NSLocalizedString("no_internet_connection", comment: "")
        btnWarning.layer.borderWidth = 1
        btnWarning.layer.borderColor =  UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0).cgColor
        lblLoading.text = NSLocalizedString("loading", comment: "")
        viewBackButton.layer.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7).cgColor
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.frame=self.view.bounds
        webView.scrollView.bounces = true
        webView.scrollView.keyboardDismissMode = .interactive

        refController.bounds = CGRect(x: 0, y: 0, width: refController.bounds.size.width, height: refController.bounds.size.height)
        refController.addTarget(self, action: #selector(refreshPage), for: UIControl.Event.valueChanged)
        refController.attributedTitle = NSAttributedString(string: NSLocalizedString("pull_to_refresh", comment: "Pull to refresh"))
        webView.scrollView.refreshControl = refController

    
        NotificationCenter.default.addObserver(self, selector: #selector(changeBottomHeight(_:)), name: Notification.Name(rawValue: "changeBottomHeight"), object: nil)

        
        let tapGestureRecognizerWhatsapp = UITapGestureRecognizer(target: self, action: #selector(imageTappedBack(tapGestureRecognizer:)))
        viewBackButton.isUserInteractionEnabled = true
        viewBackButton.addGestureRecognizer(tapGestureRecognizerWhatsapp)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
        
        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
        hideMessenger = defaults.bool(forKey: "hideMessenger")
        hideViber = defaults.bool(forKey: "hideViber")
        hideTelegram = defaults.bool(forKey: "hideTelegram")
        hideSms = defaults.bool(forKey: "hideSms")
        
   
            if Reachability2.isConnectedToNetwork(){
                if canOpenURL(url) {
                       print("valid url.")
                    webView.load(URLRequest(url: URL(string: url)!))

                   } else {
                       print("invalid url.")
                   }

            }else{
                viewWarning.isHidden = false
            }
         
  
     
        viewBackButton.layer.masksToBounds = false
        viewBackButton.layer.cornerRadius = viewBackButton.frame.height/2
        viewBackButton.clipsToBounds = true
        
        
        
    }

    @objc  func refreshPage(refresh:UIRefreshControl){
        isRefreshing = true
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        showWarning(type: "internet")
        self.refController.endRefreshing()
        self.isRefreshing = false
        self.stkLoading.isHidden = true

      

    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error)
    {
        showWarning(type: "invalid")

         self.viewWarning.isHidden = false
         self.refController.endRefreshing()
         self.isRefreshing = false
         self.stkLoading.isHidden = true

            
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {


        if(!isRefreshing){
        webView.isHidden = false
        stkLoading.isHidden = true

        if(webView.canGoBack){
            viewBackButton.isHidden = false
        }else{
            viewBackButton.isHidden = true
        }
            let script = "scrollTo(0, -500)"
            webView.evaluateJavaScript(script) { (result, error) in
                if error != nil {
                    print(result as Any)
                }
            }
      
        }
        refController.endRefreshing()
        isRefreshing = false
    }
  /*
    func takeScreenshot() -> UIImage? {
        let currentSize = webView.frame.size
        let currentOffset = webView.scrollView.contentOffset
        
        webView.frame.size = webView.scrollView.contentSize
        webView.scrollView.setContentOffset(CGPoint.zero, animated: false)
        
        let rect = CGRect(x: 0, y: 0, width: webView.bounds.size.width, height: webView.bounds.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        webView.drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        webView.frame.size = currentSize
        webView.scrollView.setContentOffset(currentOffset, animated: false)
        
        return image
    }
*/
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        if(!isRefreshing){
        stkLoading.isHidden = false
        webView.isHidden = true
        viewBackButton.isHidden = true

        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabBar"), object: nil)
        if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
            topConstraint.constant = 40
            backTopConstraint.constant = 50
        }else{
            topConstraint.constant = 275
            backTopConstraint.constant = 87

        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(stkLoading.isHidden == true){
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                navigationController?.setNavigationBarHidden(true, animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "hideTabBar"), object: nil)
                self.topConstraint.constant = 0

                DispatchQueue.main.asyncAfter(deadline: .now()+0.10 ) {
                    self.backTopConstraint.constant = 10

                }
              
            } else {
                navigationController?.setNavigationBarHidden(false, animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabBar"), object: nil)
                
                if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
                    topConstraint.constant = 40
                    backTopConstraint.constant = 50

                }else{

                    topConstraint.constant = 275
                    backTopConstraint.constant = 87
                }
            }
        }
    }
    
    @IBAction func btnWarning(_ sender: Any) {
    
            if Reachability2.isConnectedToNetwork(){
                             viewWarning.isHidden = true

                
                if canOpenURL(url) {
                                  print("valid url.") // This line executes
                               webView.load(URLRequest(url: URL(string: url)!))

                              } else {
                                  print("invalid url.")
                              }
                webView.isHidden = true
                stkLoading.isHidden = false

            }else{
                viewWarning.isHidden = false

            }
         
   
    }

  
    @objc func imageTappedBack(tapGestureRecognizer: UITapGestureRecognizer)
    {
        viewBackButton.layer.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15 ) {
            self.viewBackButton.layer.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7).cgColor
        }
        
        if(webView.canGoBack){
            webView.goBack()
        }
    }

    @objc func changeBottomHeight(_ notification: Notification) {
        bottomConstraint.constant = 0
      bottomConstraintBtn.constant = 20

    }
    
    
    @IBAction func btnEdit(_ sender: Any) {
        let url2:[String: String] = ["url": url]

        NotificationCenter.default.post(name: Notification.Name(rawValue: "openEditTabPopup"), object: nil, userInfo: url2)

        
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }


   func showWarning(type:String){
       
       if(type == "internet"){
           btnWarning.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)

           lblWarning.text = NSLocalizedString("no_internet_connection", comment: "")

       }else{
           btnWarning.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)
           lblWarning.text = NSLocalizedString("invalid_url", comment: "")
       }
       viewWarning.isHidden = false

   }
    
}
