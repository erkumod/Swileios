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
            callForgotPassAPI()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecurity"{
            let vc = segue.destination as! SecurityCodeVC
            vc.email = sender as! String
        }
    }
    
    //MARK:- Web Service Calling
    func callForgotPassAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.FORGOT_PASSWORD
        
        let parameter : [String:String] = [
            "email": tfEmail.text!
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.performSegue(withIdentifier: "toSecurity", sender: self.tfEmail.text!)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
}
