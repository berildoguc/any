//
//  GmailViewController.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 2.03.2020.
//  Copyright © 2020 HH&HS Apps. All rights reserved.
//

import UIKit
import WebKit

class GmailViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate{

    @IBOutlet weak var webView: WKWebView!
    var hideWhatsapp = true
    var hideMessenger = true
    var hideViber = true
    var hideTelegram = true
    var hideSms = true
    let defaults = UserDefaults.standard
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var username = ""
    @IBOutlet weak var stkLoading: UIStackView!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var viewWarning: UIView!
    @IBOutlet weak var imgWarning: UIImageView!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var btnWarning: UIButton!
    var url = "https://mail.google.com/"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnWarning.setTitle(NSLocalizedString("save_an_email_address", comment: ""), for: .normal)
              btnWarning.layer.borderWidth = 1
              btnWarning.layer.borderColor =  UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0).cgColor
              lblWarning.text = NSLocalizedString("no_any_email", comment: "")
              lblLoading.text = NSLocalizedString("loading", comment: "")
        
        webView.allowsBackForwardNavigationGestures = true
               webView.navigationDelegate = self
               webView.scrollView.delegate = self
               webView.frame=self.view.bounds
               webView.scrollView.bounces = true
               webView.scrollView.keyboardDismissMode = .interactive
        
            NotificationCenter.default.addObserver(self, selector: #selector(changeBottomHeight(_:)), name: Notification.Name(rawValue: "changeBottomHeight"), object: nil)

          
        
        hideWhatsapp = defaults.bool(forKey: "hideWhatsapp")
              hideMessenger = defaults.bool(forKey: "hideMessenger")
              hideViber = defaults.bool(forKey: "hideViber")
              hideTelegram = defaults.bool(forKey: "hideTelegram")
              hideSms = defaults.bool(forKey: "hideSms")
              
  
        
        if(url == "https://mail.google.com/"){
                  
                  if Reachability2.isConnectedToNetwork(){
                      webView.load(URLRequest(url: URL(string: url)!))

                  }else{
                      showWarning(type: "internet")
                  }
               
                  return
              }
              
              //Detay ekranı ise
              if(username != "" && username != " "){

                  if Reachability2.isConnectedToNetwork(){
                      url = url + username
                      webView.load(URLRequest(url: URL(string: url)!))
                      
                  }else{
                     showWarning(type: "internet")
                  }
                  

              }else{
                  showWarning(type: "username")

              }
            
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         showWarning(type: "internet")

         self.stkLoading.isHidden = true

          }
      
          func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error)
             {
                showWarning(type: "internet")
                self.stkLoading.isHidden = true
      
             }
    
      func webView(_ webView: WKWebView,
                   didFinish navigation: WKNavigation!) {
         
        print(webView.url?.description)
            webView.isHidden = false
            stkLoading.isHidden = true
        let script = "scrollTo(0, -500)"
             webView.evaluateJavaScript(script) { (result, error) in
                 if error != nil {
                     print(result as Any)
                 }
             }
     
      }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("absolute string: " + navigationAction.request.url!.absoluteString)
        if (navigationAction.navigationType == .linkActivated){
               decisionHandler(.cancel)
           } else {
               decisionHandler(.allow)
           }
        if(username != "" && username != " "){
        if (navigationAction.request.url!.absoluteString.elementsEqual("https://mail.google.com/mail/mu/")){
            if Reachability2.isConnectedToNetwork(){
                              webView.load(URLRequest(url: URL(string: url)!))
                              
                          }else{
                             showWarning(type: "internet")
                          }
        }
        }
    }
  

      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    
          stkLoading.isHidden = false
          webView.isHidden = true

          navigationController?.setNavigationBarHidden(false, animated: true)
          NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabBar"), object: nil)
          if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
              topConstraint.constant = 40
          }else{
              topConstraint.constant = 275

          }
         
      }
    
    
      override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }

      
 /*     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         // if(stkLoading.isHidden == true){
        print("barr : " + scrollView.panGestureRecognizer.translation(in: scrollView).y.description)

              if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                  navigationController?.setNavigationBarHidden(true, animated: true)
                  NotificationCenter.default.post(name: Notification.Name(rawValue: "hideTabBar"), object: nil)
                  self.topConstraint.constant = 0
                    print("hide barr")

                
              } else {
                  navigationController?.setNavigationBarHidden(false, animated: true)
                  NotificationCenter.default.post(name: Notification.Name(rawValue: "showTabBar"), object: nil)
                print("show barr")
                  
                  if(hideWhatsapp && hideMessenger && hideViber && hideTelegram && hideSms){
                      topConstraint.constant = 40

                  }else{

                      topConstraint.constant = 77
                  }
              }
         // }
      }

 */


      @objc func changeBottomHeight(_ notification: Notification) {
          bottomConstraint.constant = 0
    
      }
    
    @IBAction func btnWarning(_ sender: Any) {
        if(btnWarning.currentTitle == NSLocalizedString("try_again", comment: "")){
             if Reachability2.isConnectedToNetwork(){
                 UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                     self.viewWarning.alpha = 0.0
                     
                 }, completion: nil)
                 
                 webView.load(URLRequest(url: URL(string: "https://mail.google.com/mail/mu/mp/37/#tl/search/" + username)!))

                 webView.isHidden = true
                 stkLoading.isHidden = false
             }else{
                 showWarning(type: "internet")
             }
          
         }else{
             let colon:[String: String] = ["colon": "gmail"]

             NotificationCenter.default.post(name: Notification.Name(rawValue: "openPopup"), object: nil, userInfo: colon)

         }
    }
    
    func showWarning(type:String){
        
        if(type == "internet"){
            btnWarning.setTitle(NSLocalizedString("try_again", comment: ""), for: .normal)

            lblWarning.text = NSLocalizedString("no_internet_connection", comment: "")

        }else{
            btnWarning.setTitle(NSLocalizedString("save_an_email_address", comment: ""), for: .normal)
            lblWarning.text = NSLocalizedString("no_any_email", comment: "")
        }
        viewWarning.isHidden = false

    }
}
