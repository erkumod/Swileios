//
//  ForgotVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
    
    @IBAction func btnContinue_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation(){
            
        }
    }
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Other Function
    func checkValidation() -> Bool{
        if tfEmail.text!.isEmpty{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter email address")
            return false
        }else if !tfEmail.text!.isEmail{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter valid email address")
            return false
        }else{
            return true
        }
    }
    
    func checkValidation_continue() -> Bool{
        if !tfEmail.text!.isEmail{
            return false
        }else{
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if checkValidation_continue(){
            btnContinue.isUserInteractionEnabled = true
            btnContinue.backgroundColor = AppColors.cyan
            return true
        }else{
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = UIColor.lightGray
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if checkValidation_continue(){
            btnContinue.isUserInteractionEnabled = true
            btnContinue.backgroundColor = AppColors.cyan
            return true
        }else{
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = UIColor.lightGray
            return true
        }
        
    }
    
    //MARK:- Web Service Calling
    
}
