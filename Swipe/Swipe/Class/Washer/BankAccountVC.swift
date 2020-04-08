//
//  BankAccountVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class BankAccountVC: Main {

    @IBOutlet weak var ivBankPhoto: UIImageView!
    @IBOutlet weak var tfBankName: UITextField!
    @IBOutlet weak var tfAccNumber: UITextField!
    @IBOutlet weak var tfHolderName: UITextField!
    
    @IBOutlet weak var btnCondition1: UIButton!
    @IBOutlet weak var btnCondition2: UIButton!
    
    @IBOutlet weak var vwImage: CustomUIView!
    var condition1Flag = false
    var condition2Flag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivBankPhoto.isHidden = true
        
        if UserModel.sharedInstance().bank_name != nil{
            tfBankName.text = UserModel.sharedInstance().bank_name!
        }
        
        if UserModel.sharedInstance().account_number != nil{
            tfAccNumber.text = UserModel.sharedInstance().account_number!
        }
        
        if UserModel.sharedInstance().account_holder != nil{
            tfHolderName.text = UserModel.sharedInstance().account_holder!
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handle_ImageUpload(_:)))
        self.vwImage.isUserInteractionEnabled = true
        self.vwImage.addGestureRecognizer(tap)
        
    }
    
    @IBAction func btnCondition1_Action(_ sender: Any) {
        if condition1Flag{
            btnCondition1.setImage(UIImage(named: "empty_box"), for: .normal)
            condition1Flag = false
        }else{
            btnCondition1.setImage(UIImage(named: "fill_box"), for: .normal)
            condition1Flag = true
        }
    }
    
    @IBAction func btnCondition2_Action(_ sender: Any) {
        if condition2Flag{
            btnCondition2.setImage(UIImage(named: "empty_box"), for: .normal)
            condition2Flag = false
        }else{
            btnCondition2.setImage(UIImage(named: "fill_box"), for: .normal)
            condition2Flag = true
        }
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Action(_ sender: Any) {
        if tfHolderName.text!.isEmpty{
            self.showAlertView("Please enter account holder name")
        }else if tfAccNumber.text!.isEmpty{
            self.showAlertView("Please enter account number")
        }else if tfBankName.text!.isEmpty{
            self.showAlertView("Please enter account bank name")
        }else if !condition1Flag{
            self.showAlertView("Please check conditions")
        }else if !condition2Flag{
            self.showAlertView("Please check conditions")
        }else if ivBankPhoto.image == nil{
            self.showAlertView("Please select photo")
        }else{
            callBankDetailAPI()
        }
    }
    
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
    
    func callBankDetailAPI() {
        
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.BANK_DETAIL
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "bank_name" : tfBankName.text!,
            "account_number" : tfAccNumber.text!,
            "account_holder" : tfHolderName.text!
        ]
        
        //Starting process to fetch the data and store default login data.
        APIManager.shared.requestImageUploadDiffName(serviceURL, parameter, ivBankPhoto.image!, success: { (response) in
            
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
    
}
extension BankAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            self.ivBankPhoto.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
    }
}
