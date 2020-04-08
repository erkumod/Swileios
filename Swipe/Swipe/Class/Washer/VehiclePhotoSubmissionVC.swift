//
//  VehiclePhotoSubmissionVC.swift
//  Swipe
//
//  Created by My Mac on 06/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import Alamofire

class VehiclePhotoSubmissionVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lblVw1: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var lblVw2: UILabel!
    @IBOutlet var vwAlert: CustomUIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var lblMsg: UILabel!
    
    //MARK:- Global Variables
    var isComeFrom = "", cancelMsg = "", washID = "", isImgFrom = ""
    var selectedImg1:UIImage!, selectedImg2:UIImage!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.vwAlert.frame = CGRect(x: 15, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 30, height: 181)
        
        if isComeFrom == "cakemud"{
            vw1.isHidden = false
            vw2.isHidden = true
            lblVw1.text = "View of affected area that is heavily caked in mud"
            lblMsg.text = "Please upload photos to cancel job."
            
        }else{
            vw1.isHidden = false
            vw2.isHidden = false
            lblVw1.text = "Front view of vehicle with number plate"
            lblVw2.text = "Back view of vehicle with number plate"
            lblMsg.text = "Please upload photos to end job."
        }
        
        self.view.addSubview(vwAlert)
        self.vwAlert.center = self.view.center
        
        self.vwAlert.isHidden = true
        self.blurView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handle_ImageUpload1(_:)))
        self.img1.isUserInteractionEnabled = true
        self.img1.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handle_ImageUpload2(_:)))
        self.img2.isUserInteractionEnabled = true
        self.img2.addGestureRecognizer(tap1)
    }
    
    //MARK:- Other Methods
    func openActionSheet() {
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
    @IBAction func btnBack_ACtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Action(_ sender: CustomButton) {
        if isComeFrom == "cakemud" {
            
            if selectedImg1 == nil{
                self.vwAlert.isHidden = false
                self.blurView.isHidden = false
            }else {
                callCancelWashAPI()
            }
            
        }else {
            if selectedImg1 == nil {
                self.vwAlert.isHidden = false
                self.blurView.isHidden = false
            }else if selectedImg2 == nil {
                self.vwAlert.isHidden = false
                self.blurView.isHidden = false
            }else {
                //Call complete wash API
                callCompleteWashAPI()
            }
        }
    }
    
    @IBAction func btnAlertOk_Action(_ sender: CustomButton) {
        self.vwAlert.isHidden = true
        self.blurView.isHidden = true
    }
    
    //MARK:- Selector Method
    @objc func handle_ImageUpload1(_ recognizer: UITapGestureRecognizer) {
        isImgFrom = "one"
        openActionSheet()
    }
    
    @objc func handle_ImageUpload2(_ recognizer: UITapGestureRecognizer) {
        isImgFrom = "two"
        openActionSheet()
    }
    
    
    //MARK:- Webservices
    func callCancelWashAPI() {
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.CANCEL_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "cancel_message" : cancelMsg,
            "wash_id" : washID
        ]
        
        //Starting process to fetch the data and store default login data.
        APIManager.shared.requestImageUploadWithName(serviceURL, parameter, selectedImg1, "cancel_image", success: { (response) in
            
            //Parsing method started to parse the data.
            if let jsonObject = response.result.value as? [String:AnyObject] {
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
    
    func callCompleteWashAPI() {
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }

        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.COMPLETE_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "wash_id" : washID
        ]

        let arrImg = [selectedImg1, selectedImg2]

        //Starting process to fetch the data and store default login data.
        CommonFunctions.shared.showLoader()
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            for i in 0..<2 {

                let imgData = arrImg[i]!.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imgData!, withName: "image\(i+1)", fileName: "image\(i+1).jpeg", mimeType: "image/jpeg")
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
                                    UserModel.sharedInstance().started_Booking_id = nil
                                    UserModel.sharedInstance().synchroniseData()
                                    self.navigationController?.popToRootViewController(animated: true)
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

extension VehiclePhotoSubmissionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if self.isImgFrom == "one" {
                self.img1.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                self.selectedImg1 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }else {
                self.img2.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                self.selectedImg2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            
        }
    }
}
