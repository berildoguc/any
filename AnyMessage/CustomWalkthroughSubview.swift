//
//  CustomWalkthroughSubview.swift
//  iOS Example
//
//  Created by Rui Costa on 30/09/2015.
//  Copyright © 2015 Rui Costa. All rights reserved.
//

import UIKit

class CustomWalkthroughView: WalkthroughView {
    
    lazy var helpLabel: UILabel = self.makeHelpLabel()
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.addSubview(helpLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
         self.addSubview(helpLabel)
    }
    
    func makeHelpLabel() -> UILabel {
        let l = UILabel()
        l.backgroundColor = UIColor.clear
        l.textColor = UIColor.white
        l.font = UIFont.boldSystemFont(ofSize: 20.0)
        l.textAlignment = .center
        l.numberOfLines = 0
        
        return l
    }
}
