//
//  ChangePasswordVC.swift
//  Swipe
//
//  Created by My Mac on 18/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordVC: Main {

    @IBOutlet weak var tfCurrPass: SkyFloatingLabelTextField!
    @IBOutlet weak var tfNewPasso: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRePass: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnForgot_Action(_ sender: Any) {
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnSave_Action(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK:- Other Function
    func checkValidation() -> Bool{
        if tfCurrPass.text!.isEmpty{
            tfCurrPass.becomeFirstResponder()
            self.showAlertView("Please enter current password")
            return false
        }else if tfNewPasso.text!.isEmpty{
            tfNewPasso.becomeFirstResponder()
            self.showAlertView("Please enter new password")
            return false
        }else if tfRePass.text!.isEmpty{
            tfRePass.becomeFirstResponder()
            self.showAlertView("Please enter retype password")
            return false
        }else if tfNewPasso.text != tfRePass.text{
            tfRePass.becomeFirstResponder()
            self.showAlertView("New password and retype password does not match")
            return false
        }else{
            return true
        }
    }
    
    func checkValidation_continue() -> Bool{
        if tfCurrPass.text!.isEmpty{
            return false
        }else if tfNewPasso.text!.isEmpty{
            return false
        }else if tfRePass.text!.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if checkValidation_continue(){
            btnSave.isUserInteractionEnabled = true
            btnSave.backgroundColor = AppColors.cyan
            return true
        }else{
            btnSave.isUserInteractionEnabled = false
            btnSave.backgroundColor = UIColor.lightGray
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if checkValidation_continue(){
            btnSave.isUserInteractionEnabled = true
            btnSave.backgroundColor = AppColors.cyan
            return true
        }else{
            btnSave.isUserInteractionEnabled = false
            btnSave.backgroundColor = UIColor.lightGray
            return true
        }
        
    }
}
