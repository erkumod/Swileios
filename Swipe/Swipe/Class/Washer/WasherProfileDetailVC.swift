//
//  WasherProfileDetailVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherProfileDetailVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var consEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var consMobileHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tfEmail: CustomTextField!
    @IBOutlet weak var tfPhone: CustomTextField!
    //MARK:- Global Variables
    var isComeFrom = ""
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if isComeFrom == "email"{
            consMobileHeight.constant = 0
            consEmailHeight.constant = 140
            lblHeader.text = "Edit Email Address"
        }else{
            consEmailHeight.constant = 0
            consMobileHeight.constant = 140
            lblHeader.text = "Edit Phone Number"
        }
        
        if UserModel.sharedInstance().email != nil{
            tfEmail.text = UserModel.sharedInstance().email!
        }
        
        if UserModel.sharedInstance().mobileNo != nil{
            tfPhone.text = UserModel.sharedInstance().mobileNo!
        }
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: Any) {
        self.view.endEditing(true)
        if isComeFrom == "phone"{
            callEditPhoneAPI()
            
        }else if isComeFrom == "email"{
            //callEditEmailAPI()
        }
    }
    
    @IBAction func btnClear_Action(_ sender: Any) {
        tfEmail.text = ""
        tfPhone.text = ""
    }
    
    func callEditEmailAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfEmail.text!.isEmpty{
            self.showAlertView("Please enter email address")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.EDIT_EMAIL
        
        let parameter : [String:AnyObject] = [
            "email": tfEmail.text as AnyObject ,
            "token":UserModel.sharedInstance().authToken! as AnyObject
        ]
        
        print(parameter)
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                       (UIApplication.shared.delegate as! AppDelegate).callProfileInfoAPI()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callEditPhoneAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfEmail.text!.isEmpty{
            self.showAlertView("Please enter email address")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.EDIT_PHONE
        
        let parameter : [String:AnyObject] = [
            "mobile": tfPhone.text as AnyObject ,
            "token":UserModel.sharedInstance().authToken! as AnyObject
        ]
        
        print(parameter)
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        if let otp = jsonObject["otp"] as? String{
                            UserModel.sharedInstance().tempOTP = otp
                            UserModel.sharedInstance().synchroniseData()
                            self.performSegue(withIdentifier: "toOTP", sender: nil)
                        }
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOTP"{
            if isComeFrom == "phone"{
                let vc = segue.destination as! OTPVC
                vc.mobile_number = tfPhone.text!
            }
        }
    }
    
}
