//
//  WasherProfileDetailVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherProfileDetailVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var consEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var consMobileHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tfEmail: CustomTextField!
    @IBOutlet weak var tfPhone: CustomTextField!
    //MARK:- Global Variables
    var isComeFrom = ""
    
    //MARK:- View Life Cycle Methods
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
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinue_Action(_ sender: Any) {
        if isComeFrom == "phone"{
            self.performSegue(withIdentifier: "toOTP", sender: nil)
        }
    }
    @IBAction func btnClear_Action(_ sender: Any) {
        tfEmail.text = ""
        tfPhone.text = ""
    }
}
