//
//  ViewDeleteCardVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ViewDeleteCardVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var vwDelete: CustomUIView!
    @IBOutlet weak var imgBlur: UIImageView!
    
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var swtPrimary: UISwitch!
    
    @IBOutlet weak var lblPrimaryStatus: UILabel!
    
    //MARK:- Global Variables
    var dictData = [String:AnyObject]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if !dictData.isEmpty{
            if dictData["type"] as! String == "visa" {
                ivCard.image = UIImage(named: "color_visa")
            }else if dictData["type"] as! String == "master" {
                ivCard.image = UIImage(named: "color_master")
            }else if dictData["type"] as! String == "american" {
                ivCard.image = UIImage(named: "color_american")
            }else if dictData["type"] as! String == "dinerclub" {
                ivCard.image = UIImage(named: "dinersclub")
            }else if dictData["type"] as! String == "discover" {
                ivCard.image = UIImage(named: "discover")
            }else if dictData["type"] as! String == "jcb" {
                ivCard.image = UIImage(named: "jcb")
            }else {
                ivCard.image = UIImage(named: "default_card_new")
            }
            
            let exp_month = dictData["expiry_month"] as! String
            let exp_year = dictData["expiry_year"] as! String
            lblExp.text = "\(exp_month)/\(exp_year)"
            
            
            if dictData["primary"] as! String == "1"{
                swtPrimary.setOn(true, animated: true)
                swtPrimary.isUserInteractionEnabled = false
                
                lblPrimaryStatus.text = "Primary"
            }else{
                swtPrimary.setOn(false, animated: true)
                swtPrimary.isUserInteractionEnabled = true
                
                lblPrimaryStatus.text = "Not Primary"
            }
            
            lblCardNo.text = dictData["card_no"] as? String
            

            let card_no = dictData["card_no"] as! String
            lblCardNo.text = "**** **** **** " + String(card_no.suffix(4))
        }
        
        swtPrimary.layer.cornerRadius = 16
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
    
    //MARK:- Button Actions
    @IBAction func swtPrimary_Action(_ sender: Any) {
        callSetPrimaryCardAPI()
    }
    
    @IBAction func btnRemoveCard_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRemove_Action(_ sender: Any) {
        callDeleteCardAPI()
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
    
    //MARK:- Webservices
    func callDeleteCardAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
     
        let serviceURL = Constant.WEBURL + Constant.API.DELETE_CARD
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "card_id": "\(dictData["id"] as! Int)"
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.vwDelete.isHidden = true
                        self.imgBlur.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callSetPrimaryCardAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.PRIMARY_CARD
        
        var primary = 0
        if self.swtPrimary.isOn{
            primary = 1
        }else{
            primary = 0
        }
        
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "card_id": "\(dictData["id"] as! Int)",
            "primary":"\(primary)"
        ]
        
        APIManager.shared.requestNoLoaderPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
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
