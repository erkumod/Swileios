//
//  EditProfileVC.swift
//  Swipe
//
//  Created by My Mac on 16/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class EditProfileVC: Main {

    @IBOutlet weak var vwLogout: UIView!
    @IBOutlet weak var blurView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blurView.isHidden = true
        vwLogout.isHidden = true
    }

    @IBAction func btnBack_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnLogOut_Action(_ sender: Any) {
        blurView.isHidden = false
        vwLogout.isHidden = false
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        blurView.isHidden = true
        vwLogout.isHidden = true
    }
    
    @IBAction func btnLogout_Action(_ sender: Any) {
        blurView.isHidden = true
        vwLogout.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).ChangeToLogin()
    }
    
    @IBAction func btnChangePassword_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toPassword", sender: nil)
    }
    
    @IBAction func btnAccountSetting_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toAccount", sender: nil)
    }
    
    
}
