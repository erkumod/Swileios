//
//  AccountSettingVC.swift
//  Swipe
//
//  Created by My Mac on 18/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class AccountSettingVC: Main {

    @IBOutlet weak var swtBookingUpdate: UISwitch!
    @IBOutlet weak var swtEmail: UISwitch!
    @IBOutlet weak var swtSMS: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetAcocountSettingAPI()
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave_Action(_ sender: Any) {
        callSaveAccountSettingAPI()
    }
    
    func callGetAcocountSettingAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.ACCOUNT_SETTING
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        
                        if let account = jsonObject["accountsetting"] as? [String:AnyObject] {
                            
                            if account["email_updates"] as! String == "yes"{
                                self.swtEmail.setOn(true, animated: true)
                            }else{
                                self.swtEmail.setOn(false, animated: true)
                            }
                            
                            if account["sms_updates"] as! String == "yes"{
                                self.swtSMS.setOn(true, animated: true)
                            }else{
                                self.swtSMS.setOn(false, animated: true)
                            }
                            
                            if account["booking_updates"] as! String == "yes"{
                                self.swtBookingUpdate.setOn(true, animated: true)
                            }else{
                                self.swtBookingUpdate.setOn(false, animated: true)
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callSaveAccountSettingAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        var booking_updates = ""
        var sms_updates = ""
        var email_updates = ""
        
        if swtBookingUpdate.isOn{
            booking_updates = "yes"
        }else{
            booking_updates = "no"
        }
        
        if swtSMS.isOn{
            sms_updates = "yes"
        }else{
            sms_updates = "no"
        }
        
        if swtEmail.isOn{
            email_updates = "yes"
        }else{
            email_updates = "no"
        }
  
        
        let serviceURL = Constant.WEBURL + Constant.API.ACCOUNT_SETTING
        
        let parameter : [String:String] = [
            "booking_updates":booking_updates,
            "email_updates":email_updates,
            "sms_updates":sms_updates,
            "token": UserModel.sharedInstance().authToken!
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }) { (error) in
            print(error)
        }
    }

}
