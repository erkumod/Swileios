//
//  WasherProfileVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherProfileVC: Main {

    @IBOutlet weak var ivPic: CustomImageView!
    @IBOutlet weak var lblUpCnt: UILabel!
    @IBOutlet weak var lblDownCnt: UILabel!
    
    @IBOutlet weak var tfEmail: CustomTextField!
    @IBOutlet weak var tfPhone: CustomTextField!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAccNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblUpCnt.text = UserModel.sharedInstance().upvote_count
        lblDownCnt.text = UserModel.sharedInstance().downvote_count
        lblUserName.text = UserModel.sharedInstance().name
        
        if UserModel.sharedInstance().profile_image != nil{
            ivPic.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(UserModel.sharedInstance().profile_image!)"))
        }
        
        
        if UserModel.sharedInstance().email != nil{
            tfEmail.text = UserModel.sharedInstance().email!
        }
        
        if UserModel.sharedInstance().mobileNo != nil{
            tfPhone.text = UserModel.sharedInstance().mobileNo!
        }
        
        if UserModel.sharedInstance().name != nil{
            lblUserName.text = UserModel.sharedInstance().name!
        }
        
        if UserModel.sharedInstance().bank_name != nil{
            lblBankName.text = UserModel.sharedInstance().bank_name!
        }else{lblBankName.text = ""}
        
        if UserModel.sharedInstance().account_number != nil{
            lblAccNumber.text = UserModel.sharedInstance().account_number!
        }else{lblAccNumber.text = ""}
        
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }
    
    @IBAction func btnEmailAddress_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetail", sender: "email")
    }
    
    @IBAction func btnPhoneAddress_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetail", sender: "phone")
    }
    
    @IBAction func btnAccountDetail_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toBank", sender: nil)
    }
    
    @IBAction func btnTerms_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toStatic", sender: "term")
    }
    
    @IBAction func btnSpecialist_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toStatic", sender: "special")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail"{
            let vc = segue.destination as! WasherProfileDetailVC
            vc.isComeFrom = sender as! String
        }else if segue.identifier == "toStatic"{
            let vc = segue.destination as! WasherStaticPagesVC
            vc.isComeFrom = sender as! String
        }
        
    }
    
}
