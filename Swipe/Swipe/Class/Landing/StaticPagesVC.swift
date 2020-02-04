//
//  StaticPagesVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class StaticPagesVC: Main {
    
    //MARK:- Outlets
    var comeFrom = ""
    
    @IBOutlet weak var lblHeader: UILabel!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if comeFrom == "terms"{
            lblHeader.text = "Terms of Service"
        }else{
            lblHeader.text = "Privacy Policy"
        }
        
    }
    
    
    
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    //MARK:- Other Function
    
    //MARK:- Web Service Calling
    
}
