//
//  JoinUsVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import Alamofire

class JoinUsVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var vwConfirm: UIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var tfEmail: CustomTextField!
    @IBOutlet weak var tfPhoneNo: CustomTextField!
    @IBOutlet weak var tfDOB: CustomTextField!
    @IBOutlet weak var lblFrontPic: UILabel!
    @IBOutlet weak var lblBackPic: UILabel!
    @IBOutlet weak var lblFaceNIRC: UILabel!
    
    //MARK:- Global Variables
    var ivFront = UIImage()
    var ivBack = UIImage()
    var ivFace_NIRC = UIImage()
    
    var click_Front = false, isFrontSelected = false
    var click_Back = false, isBackSelected = false
    var click_Face_NIRC = false, isFaceNIRCSelected = false
    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.isHidden = true
        vwConfirm.isHidden = true
        
        if UserModel.sharedInstance().email != nil && UserModel.sharedInstance().email! != "" {
            tfEmail.text = UserModel.sharedInstance().email!
        }
        
        if UserModel.sharedInstance().dob != nil && UserModel.sharedInstance().dob! != "" {
            tfDOB.text = UserModel.sharedInstance().dob!
        }
        
        if UserModel.sharedInstance().mobileNo != nil && UserModel.sharedInstance().mobileNo! != "" {
            tfPhoneNo.text = UserModel.sharedInstance().mobileNo!
        }
    }
    
    //MARK:- Other Methods
    func openGallery_Camera(){
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
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }

    @IBAction func btnFrontPic_Action(_ sender: Any) {
        click_Front = true
        click_Back = false
        click_Face_NIRC = false
        openGallery_Camera()
    }
    
    @IBAction func btnBackPic_Action(_ sender: Any) {
        click_Front = false
        click_Back = true
        click_Face_NIRC = false
        openGallery_Camera()
    }
    
    @IBAction func btnFace_NIRC_Pic_Action(_ sender: Any) {
        click_Front = false
        click_Back = false
        click_Face_NIRC = true
        openGallery_Camera()
    }
    
    @IBAction func btnSignUp_Action(_ sender: Any) {
        
        if tfDOB.text! == "" {
            CommonFunctions.shared.showToast(self.view, "Please add DOB From Edit Profile !!")
        }else if tfPhoneNo.text! == "" {
            CommonFunctions.shared.showToast(self.view, "Please add Mobile No From Edit Profile !!")
        }else if !isFrontSelected {
            CommonFunctions.shared.showToast(self.view, "Please Upload an Front Side Image !!")
        }else if !isBackSelected {
            CommonFunctions.shared.showToast(self.view, "Please Upload an Back Side Image !!")
        }else if !isFaceNIRCSelected {
            CommonFunctions.shared.showToast(self.view, "Please Upload an Face With NIRC Image !!")
        }else {
            callJoinUsAPI()
        }
    }
    
    @IBAction func btnConfirmOk_Action(_ sender: Any) {
        blurView.isHidden = true
        vwConfirm.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    //MARK:- Webservices
    func callJoinUsAPI() {
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.WASHER_REQUEST
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "requester_name" : UserModel.sharedInstance().name!,
            "requester_email" : tfEmail.text!,
            "requester_dob" : tfDOB.text! ,
            "requester_mobile" : tfPhoneNo.text!
        ]
        
        let arrKey = ["requester_front_pic", "requester_back_pic"]
        let arrImg = [ivFront, ivBack]

        //Starting process to fetch the data and store default login data.
        CommonFunctions.shared.showLoader()
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            for i in 0..<2 {
                let imgData = arrImg[i].jpegData(compressionQuality: 0.5)
                multipartFormData.append(imgData!, withName: arrKey[i], fileName: "\(arrKey).jpeg", mimeType: "image/jpeg")
            }

            for (key, value) in parameter {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }

        }, to: serviceURL) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    CommonFunctions.shared.showLoader(Float(progress.fractionCompleted))
                })
                upload.responseJSON { response in
                    CommonFunctions.shared.hideLoader()
                    if response.response?.statusCode == 200 {
                        if let jsonObject = response.result.value as? [String:AnyObject] {
                            if let status = jsonObject["status"] as? Int{
                                if status == 200{
                                    self.blurView.isHidden = false
                                    self.vwConfirm.isHidden = false
                                    UserModel.sharedInstance().isWasher = "1"
                                    UserModel.sharedInstance().synchroniseData()
                                    (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
                                }
                            }
                        }
                    }else {
                        print(response.result.error!)
                    }
                }
            case .failure(let encodingError):
                CommonFunctions.shared.hideLoader()
                print(encodingError)
            }
        }
    }
}

extension JoinUsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) {
            
            if self.click_Front{
                self.ivFront = info[.editedImage] as! UIImage
                self.isFrontSelected = true
                self.lblFrontPic.text = "front_side.png"
            }else if self.click_Back{
                self.ivBack = info[.editedImage] as! UIImage
                self.isBackSelected = true
                self.lblFrontPic.text = "back_side.png"
            }else if self.click_Face_NIRC{
                self.ivFace_NIRC = info[.editedImage] as! UIImage
                self.isFaceNIRCSelected = true
            }
            
        }
    }
}
