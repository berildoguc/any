//
//  FacebookViewController.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 31.08.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit
import WebKit

class FacebookViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var stkLoading: UIStackView!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet var viewWarning: UIView!
    @IBOutlet var imgWarning: UIImageView!
    @IBOutlet var lblWarning: UILabel!
    @IBOutlet var btnWarning: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var btnBack: UIImageView!
    @IBOutlet var viewBackButton: UIView!
    @IBOutlet var backTopConstraint: NSLayoutConstraint!
    var url = "https://www.facebook.com"
    var userName = ""
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    let defaults = UserDefaults.standard
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var refController:UIRefreshControl = UIRefreshControl()
    var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnWarning.setTitle(NSLocalizedString("save_a_username", comment: ""), for: .normal)
        btnWarning.layer.borderWidth = 1
        btnWarning.layer.borderColor =  UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0).cgColor
        lblWarning.text = NSLocalizedString("no_any_username", comment: "")
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

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedBack(tapGestureRecognizer:)))
        viewBackButton.isUserInteractionEnabled = true
        viewBackButton.addGestureRecognizer(tapGestureRecognizer)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
        
        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
        hideMessenger = defaults.bool(forKey: "hideMessenger")
        hideViber = defaults.bool(forKey: "hideViber")
        hideTelegram = defaults.bool(forKey: "hideTelegram")
        hideSms = defaults.bool(forKey: "hideSms")
        
        viewBackButton.layer.masksToBounds = false
        viewBackButton.layer.cornerRadius = viewBackButton.frame.height/2
        viewBackButton.clipsToBounds = true
        //Profil ekranı ise
        if(url == "https://m.facebook.com/login"){
            
            if Reachability2.isConnectedToNetwork(){
                webView.load(URLRequest(url: URL(string: url)!))

            }else{
                showWarning(type: "internet")
            }
         
            return
        }
        
        //Detay ekranı ise
        if(userName != "" && userName != " "){

            if Reachability2.isConnectedToNetwork(){
                url = url + userName
                webView.load(URLRequest(url: URL(string: url)!))
                
            }else{
               showWarning(type: "internet")
            }
            

        }else{
            showWarning(type: "username")

        }
     
        
        
        
    }

    @objc  func refreshPage(refresh:UIRefreshControl){
        isRefreshing = true
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showWarning(type: "internet")
        refController.endRefreshing()
        isRefreshing = false
        self.stkLoading.isHidden = true

        }
    
        func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error)
           {
            showWarning(type: "internet")

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
    
        if(btnWarning.currentTitle == NSLocalizedString("try_again", comment: "")){
            if Reachability2.isConnectedToNetwork(){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.viewWarning.alpha = 0.0
                    
                }, completion: nil)
                
                webView.load(URLRequest(url: URL(string: url+userName)!))
                
                webView.isHidden = true
                stkLoading.isHidden = false
            }else{
                showWarning(type: "internet")
            }
         
        }else{
            let colon:[String: String] = ["colon": "fb"]

            NotificationCenter.default.post(name: Notification.Name(rawValue: "openPopup"), object: nil, userInfo: colon)

        }
    }
    
    func showWarning(type:String){
        
        if(type == "internet"){
            btnWarning.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)

            lblWarning.text = NSLocalizedString("no_internet_connection", comment: "")

        }else{
            btnWarning.setTitle(NSLocalizedString("save_a_username", comment: ""), for: .normal)
            lblWarning.text = NSLocalizedString("no_any_username", comment: "")
        }
        viewWarning.isHidden = false

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
  
    }
    
}
