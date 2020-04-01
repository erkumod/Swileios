//
//  OTPVC.swift
//  Swipe
//
//  Created by My Mac on 01/01/1942 .
//  Copyright © 1942 Mahajan. All rights reserved.
//

import UIKit

class OTPVC: Main {
    
    @IBOutlet weak var tf1: CustomTextField!
    @IBOutlet weak var tf2: CustomTextField!
    @IBOutlet weak var tf3: CustomTextField!
    @IBOutlet weak var tf4: CustomTextField!
    @IBOutlet weak var tf5: CustomTextField!
    @IBOutlet weak var tf6: CustomTextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    var mobile_number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Please enter the verification  code that is  send to your phone number +65 \(mobile_number)"
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    

    @IBAction func btnBack_Actio0n(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnContinue_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callVerifyOTPApi()
        }
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
            case tf5:
                tf6.becomeFirstResponder()
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
            case tf6:
                tf5.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func checkValidation() -> Bool{
        if tf1.text!.isEmpty || tf2.text!.isEmpty || tf3.text!.isEmpty || tf4.text!.isEmpty || tf5.text!.isEmpty || tf6.text!.isEmpty {
            return false
        }else{
            return true
        }
    }
    
    func callVerifyOTPApi() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        
        let serviceURL = Constant.WEBURL + Constant.API.VERIFY_TEMP_OTP
        
        let otp = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)\(tf5.text!)\(tf6.text!)"
        
        let parameter : [String:AnyObject] = [
            "otp":  otp as AnyObject,
            "mobile" : mobile_number as AnyObject,
            "token":UserModel.sharedInstance().authToken! as AnyObject
        ]
        
        print(parameter)
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }

}
