//
//  JoinUsVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class JoinUsVC: Main {

    var ivFront = UIImageView()
    var ivBack = UIImageView()
    var ivFace_NIRC = UIImageView()
    
    var click_Front = false
    var click_Back = false
    var click_Face_NIRC = false
    
    @IBOutlet weak var vwConfirm: UIView!
    @IBOutlet weak var blurView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.isHidden = true
        vwConfirm.isHidden = true
       
    }
    
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
        blurView.isHidden = false
        vwConfirm.isHidden = false
    }
    
    @IBAction func btnConfirmOk_Action(_ sender: Any) {
        blurView.isHidden = true
        vwConfirm.isHidden = true
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
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
    
}
extension JoinUsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        self.dismiss(animated: true) {
            
            if self.click_Front{
                self.ivFront.image = info[.editedImage] as? UIImage
            }else if self.click_Back{
                self.ivBack.image = info[.editedImage] as? UIImage
            }else if self.click_Face_NIRC{
                self.ivFace_NIRC.image = info[.editedImage] as? UIImage
            }
            
        }
    }
}
