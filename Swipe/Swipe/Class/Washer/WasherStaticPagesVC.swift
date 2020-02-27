//
//  WasherStaticPagesVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherStaticPagesVC: Main {

    @IBOutlet weak var lblHeader: UILabel!
    var isComeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComeFrom == "term"{
            self.lblHeader.text = "Terms os Service"
        }else{
            self.lblHeader.text = "Specialist Code of Conduct"
        }

        
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
