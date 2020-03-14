//
//  SetPasswordVC.swift
//  Swipe
//
//  Created by My Mac on 18/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SetPasswordVC: Main {
    
    @IBOutlet weak var tfNewPass: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRetypPass: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var ivNewMark: UIImageView!
    @IBOutlet weak var ivRetypeMark: UIImageView!
    var email = ""
    var strOTP = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func checkValidation() -> Bool{
        if tfNewPass.text!.isEmpty{
            tfNewPass.becomeFirstResponder()
            self.showAlertView("Please enter new password")
            return false
        }else if tfRetypPass.text!.isEmpty{
            tfRetypPass.becomeFirstResponder()
            self.showAlertView("Please enter retype password")
            return false
        }else if tfNewPass.text != tfRetypPass.text{
            tfRetypPass.becomeFirstResponder()
            self.showAlertView("New password and retype password does not match")
            return false
        }else{
            return true
        }
    }
    
    func checkValidation_continue() -> Bool{
        if tfNewPass.text!.isEmpty{
            return false
        }else if tfRetypPass.text!.isEmpty{
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
        
        if tfNewPass.text!.isEmpty{
            ivNewMark.image = UIImage(named: "wrong")
        }else{
            ivNewMark.image = UIImage(named: "right")
        }
        
        if tfRetypPass.text!.isEmpty{
            ivRetypeMark.image = UIImage(named: "wrong")
        }else{
            ivRetypeMark.image = UIImage(named: "right")
        }
        
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
   
    @IBAction func btnSave_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callSetPassAPI()
        }
    }
    
    func callSetPassAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
       
        
        let serviceURL = Constant.WEBURL + Constant.API.VALIDATE_PASS
        
        let parameter : [String:String] = [
            "email": email,
            "otp":strOTP,
            "password":tfNewPass.text!
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        (UIApplication.shared.delegate as! AppDelegate).ChangeToLogin()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
}
