//
//  WasherProfileDetailVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherProfileDetailVC: Main {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var consEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var consMobileHeight: NSLayoutConstraint!
    
    var isComeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isComeFrom == "email"{
            consMobileHeight.constant = 0
            consEmailHeight.constant = 140
            lblHeader.text = "Edit Email Address"
        }else{
            consEmailHeight.constant = 0
            consMobileHeight.constant = 140
            lblHeader.text = "Edit Phone Number"
        }
        
        
    }
        
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
