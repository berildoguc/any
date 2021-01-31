//
//  IntroViewController.swift
//  Maniau1
//
//  Created by kevin on 2017. 2. 24..
//  Copyright © 2017년 warumono. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDelegate
{
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet var btnPrev: UIButton!
    @IBOutlet var btnNext: UIButton!
    let defaults = UserDefaults.standard

    fileprivate var introPageViewController: IntroPageViewController?
	{
		didSet
		{
			introPageViewController?.introPageViewControllerDataSource = self
			introPageViewController?.introPageViewControllerDelegate = self
		}
	}

    override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return .lightContent
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        passButton.layer.masksToBounds = true
        passButton.layer.cornerRadius = 14
        btnNext.layer.masksToBounds = true
        btnNext.layer.cornerRadius = 14
        btnNext.layer.borderWidth = 1
        btnNext.layer.borderColor = UIColor.white.cgColor
        btnPrev.layer.masksToBounds = true
        btnPrev.layer.cornerRadius = 14
        btnPrev.layer.borderWidth = 1
        btnPrev.layer.borderColor = UIColor.white.cgColor
        btnPrev.isHidden = true
        btnPrev.setTitle(NSLocalizedString("previous", comment: ""), for: .normal)
        btnNext.setTitle(NSLocalizedString("next", comment: ""), for: .normal)

		// Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(hidePrevButton(_:)), name: Notification.Name(rawValue: "hidePrevButton"), object: nil)

		pageControl.addTarget(self, action: #selector(IntroViewController.didChangePage), for: .valueChanged)
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let introPageViewController = segue.destination as? IntroPageViewController
		{
			self.introPageViewController = introPageViewController
		}
	}
    

    
    @objc func hidePrevButton(_ notification: Notification) {
        
        if(btnPrev.isHidden){
            btnNext.setTitle(NSLocalizedString("done", comment: ""), for: .normal)

            self.btnPrev.isHidden = false
         

        }else{
            btnNext.setTitle(NSLocalizedString("next", comment: ""), for: .normal)

            self.btnPrev.isHidden = true

        }
    }
}

extension IntroViewController
{
	@IBAction func didTouch(_ sender: UIButton)
	{
		if sender.tag == 0
		{
	
            if pageControl.currentPage-1 < 0
            {
                return
            }
			introPageViewController?.pageTo(at: 0)
		}
		else if sender.tag == 1
		{
            if(sender.currentTitle == NSLocalizedString("next", comment: "")){
                introPageViewController?.pageTo(at: 1)

            }else{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDataContacts"), object: nil)
                navigationController?.popViewController(animated: true)
                defaults.set(false, forKey: "firstSession")
                defaults.synchronize()
                dismiss(animated: true, completion: nil)
            }
		}
	}
	
	@objc fileprivate func didChangePage()
	{
        introPageViewController?.pageTo(at: pageControl.currentPage)

        if(btnPrev.isHidden){
            btnNext.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
            
            self.btnPrev.isHidden = false
            
            
        }else{
            btnNext.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
            
            self.btnPrev.isHidden = true
            
        }

	}
}

extension IntroViewController: IntroPageViewControllerDataSource
{
	func introPageViewController(_ pageViewController: IntroPageViewController, numberOfPages pages: Int)
	{
		pageControl.numberOfPages = pages
	}
}

extension IntroViewController: IntroPageViewControllerDelegate
{
	func introPageViewController(_ pageViewController: IntroPageViewController, didChangePageIndex index: Int)
	{
		pageControl.currentPage = index
	}
}
