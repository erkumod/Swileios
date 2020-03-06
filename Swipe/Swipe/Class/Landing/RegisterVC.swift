//
//  RegisterVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPass: SkyFloatingLabelTextField!
    @IBOutlet weak var tfConfPass: SkyFloatingLabelTextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var btnPass: UIButton!
    @IBOutlet weak var btnRePass: UIButton!
    var togglePass = false
    var toggleRePass = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    
    
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callRegisterAPI()
        }
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
    
    @IBAction func btnRePass_Action(_ sender: Any) {
        if toggleRePass{
            btnRePass.setImage(UIImage(named: "eye_hidden"), for: .normal)
            toggleRePass = false
            tfConfPass.isSecureTextEntry = true
        }else{
            btnRePass.setImage(UIImage(named: "eye"), for: .normal)
            toggleRePass = true
            tfConfPass.isSecureTextEntry = false
        }
    }
    
    //MARK:- Other Function
    func checkValidation() -> Bool{
        if tfName.text!.isEmpty{
            tfName.becomeFirstResponder()
            self.showAlertView("Please enter name")
            return false
        }else if tfMobile.text!.isEmpty{
            tfMobile.becomeFirstResponder()
            self.showAlertView("Please enter mobile number")
            return false
        }else if tfEmail.text!.isEmpty{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter email address")
            return false
        }else if tfPass.text!.isEmpty{
            tfPass.becomeFirstResponder()
            self.showAlertView("Please enter password")
            return false
        }else if tfConfPass.text!.isEmpty{
            tfConfPass.becomeFirstResponder()
            self.showAlertView("Please enter retype password")
            return false
        }else if !tfEmail.text!.isEmail{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter valid email address")
            return false
        }else if !validate(value: tfPass.text!){
            tfPass.becomeFirstResponder()
            self.showAlertView("Please enter valid password")
            return false
        }else if tfPass.text != tfConfPass.text{
            tfConfPass.becomeFirstResponder()
            self.showAlertView("Pass and Retype password does not match")
            return false
        }else{
            return true
        }
    }
    
    func checkValidation_continue() -> Bool{
        if tfName.text!.isEmpty{
            return false
        }else if tfMobile.text!.isEmpty{
            return false
        }else if tfEmail.text!.isEmpty{
            return false
        }else if tfPass.text!.isEmpty{
            return false
        }else if tfConfPass.text!.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    func validate(value: String) -> Bool {
        let PASS_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
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
            
            if tfMobile == textField{
                guard let textFieldText = textField.text,
                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                        return false
                }
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                
                return count <= 8
            }
            
            return true
        }else{
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = UIColor.lightGray
            
            if tfMobile == textField{
                guard let textFieldText = textField.text,
                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                        return false
                }
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                return count <= 8
            }
            return true
        }
    }
    
    //MARK:- Web Service Calling
    func callRegisterAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.REGISTER
        //let params = "?email=\(tfEmail.text!)&password=\(tfPass.text!)"
        
        let parameter : [String:AnyObject] = ["name" : tfName.text as AnyObject, "mobile" : tfMobile.text as AnyObject, "email" : tfEmail.text as AnyObject, "password" : tfPass.text as AnyObject ,"dob" : "00-00-0000" as AnyObject,"gender" : "Male" as AnyObject]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["success"] as? Bool{
                    if !status{
                        print("Failed")
               
                        var flag = false
                        if let status = jsonObject["error"] as? [String:AnyObject]{
                            if let email = status["email"] as? [String]{
                                flag = true
                                self.showAlertView(email[0])
                            }
                            
                            if !flag{
                                if let mobile = status["mobile"] as? [String]{
                                    self.showAlertView(mobile[0])
                                }
                            }
                        }
                        
                    }else{
                        print(jsonObject)
                        
                        self.showAlertView(jsonObject["error"] as? String, completionHandler: { (finish) in
                            (UIApplication.shared.delegate as? AppDelegate)?.ChangeToLogin()
                        })

                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
}
