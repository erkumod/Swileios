//
//  EditProfileVC.swift
//  Swipe
//
//  Created by My Mac on 16/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class EditProfileVC: Main {

    //MARK:- Outlets
    
    @IBOutlet weak var ivProfile: CustomImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfName: CustomTextField!
    @IBOutlet weak var tfMobile: CustomTextField!
    @IBOutlet weak var tfCountryCode: UILabel!
    @IBOutlet weak var tfEmail: CustomTextField!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserModel.sharedInstance().name != nil{
            tfName.text = UserModel.sharedInstance().name!
            
            lblName.text = UserModel.sharedInstance().name!
        }
        
        if UserModel.sharedInstance().email != nil{
            tfEmail.text = UserModel.sharedInstance().email!
        }
        
        if UserModel.sharedInstance().email != nil{
            tfEmail.text = UserModel.sharedInstance().email!
        }
        
        if UserModel.sharedInstance().profile_image != nil{
            ivProfile.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(UserModel.sharedInstance().profile_image!)"))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handle_ImageUpload(_:)))
        self.ivProfile.isUserInteractionEnabled = true
        self.ivProfile.addGestureRecognizer(tap)
        
    }

    //MARK:- Selector Methods
    //Image Upload handle mehtod to open the picker of options.
    @objc func handle_ImageUpload(_ recognizer: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let action1 = UIAlertAction(title: "Gallery", style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                imagePicker.sourceType = .photoLibrary
            }
            self.present(imagePicker, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- Button Actions
    @IBAction func btnSave_Action(_ sender: Any) {
        self.view.endEditing(true)
        if checkValidation(){
            callEditProfileAPI()
        }
    }
    @IBAction func btnBack_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnLogOut_Action(_ sender: Any) {
        self.showAlertView("Are you sure you want to logout?", defaultTitle: "Yes", cancelTitle: "No") { (finish) in
            if finish{
                print("Yes")
                self.callLogoutAPI()
            }else{
                print("No")
            }
        }
        //
    }
    
    
    @IBAction func btnChangePassword_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toPassword", sender: nil)
    }
    
    @IBAction func btnAccountSetting_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toAccount", sender: nil)
    }
    
    //MARK:- Other Methods
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
        }else if !tfEmail.text!.isEmail{
            tfEmail.becomeFirstResponder()
            self.showAlertView("Please enter valid email address")
            return false
        }else{
            return true
        }
    }
    
    //MARK:- Webservices
    func callEditProfileAPI() {
        
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.UPDATE_INFO
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "name" : tfName.text!,
            "mobile" : tfMobile.text!,
            "email" : tfEmail.text! ,
            "dob" : "00-00-0000",
            "gender" : "Male",
            "id" : UserModel.sharedInstance().user_id!,
            "profession": "Student"
        ]
        
        //Starting process to fetch the data and store default login data.
        APIManager.shared.requestImageUpload(serviceURL, parameter, ivProfile.image!, success: { (response) in
            
            //Parsing method started to parse the data.
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        (UIApplication.shared.delegate as! AppDelegate).callProfileInfoAPI()
                        self.showAlertView("Profile Updates Successfully.")
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callLogoutAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.LOGOUT
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)&os=ios"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let success = jsonObject["success"] as? Int, success == 1 {
                    UserModel.sharedInstance().removeData()
                    UserModel.sharedInstance().synchroniseData()
                    (UIApplication.shared.delegate as! AppDelegate).ChangeToLogin()
                }
            }
        }) { (error) in
            print(error)
        }
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            self.ivProfile.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
    }
}
