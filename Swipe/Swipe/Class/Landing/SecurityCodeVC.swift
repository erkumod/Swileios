//
//  SecurityCodeVC.swift
//  Swipe
//
//  Created by My Mac on 18/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class SecurityCodeVC: Main {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tf1: CustomTextField!
    @IBOutlet weak var tf2: CustomTextField!
    @IBOutlet weak var tf3: CustomTextField!
    @IBOutlet weak var tf4: CustomTextField!
    @IBOutlet weak var tf5: CustomTextField!
    
    var strOTP = String()
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        lblEmail.text = "\(email.first!)*****@gmail.com"
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                tf5.becomeFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case tf1:
                tf1.becomeFirstResponder()
            case tf2:
                tf1.becomeFirstResponder()
            case tf3:
                tf2.becomeFirstResponder()
            case tf4:
                tf3.becomeFirstResponder()
            case tf5:
                tf4.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callVerifyOTPAPI()
        }
    }
    
    func checkValidation() -> Bool{
        if tf1.text!.isEmpty || tf2.text!.isEmpty || tf3.text!.isEmpty || tf4.text!.isEmpty || tf5.text!.isEmpty {
            return false
        }else{
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPassword"{
            let vc = segue.destination as! SetPasswordVC
            vc.email = sender as! String
            vc.strOTP = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)\(tf5.text!)"
        }
    }
    
    func callVerifyOTPAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        strOTP = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)\(tf5.text!)"
        
        let serviceURL = Constant.WEBURL + Constant.API.VERIFY_OTP
        
        let parameter : [String:String] = [
            "email": email,
            "otp":strOTP
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        
                        if jsonObject["message"] as? String == "Otp verified"{
                            self.performSegue(withIdentifier: "toPassword", sender: self.email)
                        }else{
                            self.showAlertView("Enter OTP wrong")
                        }
                        
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    
}
