//
//  LoginVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPass: SkyFloatingLabelTextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnPass: UIButton!
    
    var togglePass = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //lblOr.text = "Login".localize
        
    }
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callLoginAPI()
        }
    }
    
    @IBAction func btnForgot_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgot", sender: nil)
    }
    
    @IBAction func btnPass_Action(_ sender: Any) {
        if togglePass{
            btnPass.setImage(UIImage(named: "eye_hidden"), for: .normal)
            togglePass = false
            tfPass.isSecureTextEntry = true
        }else{
            btnPass.setImage(UIImage(named: "eye"), for: .normal)
            togglePass = true
            tfPass.isSecureTextEntry = false
        }
    }
    
    
   
    //MARK:- Other Function
    func checkValidation() -> Bool{
        if tfEmail.text!.isEmpty{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter email address")
            return false
        }else if tfPass.text!.isEmpty{
            tfPass.becomeFirstResponder()
            self.showAlertView("Please enter password")
            return false
        }else if !tfEmail.text!.isEmail{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter valid email address")
            return false
        }else{
            return true
        }
        
        
//        else if !validate(value: tfPass.text!){
//            tfPass.becomeFirstResponder()
//            self.showAlertView("Please enter valid password")
//            return false
//        }
//
    }
    
    func checkValidation_continue() -> Bool{
        if tfEmail.text!.isEmpty{
            return false
        }else if tfPass.text!.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    func validate(value: String) -> Bool {
        let PASS_REGEX = "^(?=.*[A-Za-z])[A-Za-z]{8,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PASS_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
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
    func callLoginAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.LOGIN
        
        let parameter : [String:AnyObject] = ["email":tfEmail.text! as AnyObject , "password" : tfPass.text! as AnyObject]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["success"] as? Bool{
                    if !status{
                        print("Failed")
                        self.showAlertView(jsonObject["error"] as? String)
                    }else{
                        print(jsonObject)
                        if let data = jsonObject["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String:AnyObject] {
                                
                                UserModel.sharedInstance().user_id = "\(user["id"] as! Int)"
                                UserModel.sharedInstance().authToken = data["token"] as? String
                                
                                UserModel.sharedInstance().email = user["email"] as? String
                                UserModel.sharedInstance().password = self.tfPass.text!
                                UserModel.sharedInstance().mobileNo = user["mobile"] as? String
                                UserModel.sharedInstance().country_code = user["country_code"] as? String
                                
                                UserModel.sharedInstance().name = user["name"] as? String
                                UserModel.sharedInstance().user_type = user["user_type"] as? String
                                
                                UserModel.sharedInstance().synchroniseData()
            
                                (UIApplication.shared.delegate as? AppDelegate)?.callProfileInfoAPI()
                                (UIApplication.shared.delegate as? AppDelegate)?.ChangeToHome()
                            } else {
                                self.showAlertView("Someting went wrong")
                            }
                        } else {
                            self.showAlertView("Someting went wrong")
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
}
