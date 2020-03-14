//
//  PromoCodeVC.swift
//  Swipe
//
//  Created by My Mac on 18/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class PromoCodeVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var tfPromoCode: CustomTextField!
    @IBOutlet weak var lblNoPromo: UILabel!
    @IBOutlet weak var cvPromoCode: UICollectionView!
    
    //MARK:- Global Variables
    var arrPromoList = [[String:AnyObject]]()
    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetPromoListAPI()
    }
    
    //MARK:- Selector Method
    @objc func btnUse_Action(_ sender:UIButton) {
        UserModel.sharedInstance().selectedPromoType = arrPromoList[sender.tag]["type"] as? String
        UserModel.sharedInstance().selectedPromoCode = arrPromoList[sender.tag]["code"] as? String
        UserModel.sharedInstance().synchroniseData()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        if(tfPromoCode.text!.isEmpty) {
            CommonFunctions.shared.showToast(self.view, "Please provide promo code!!")
        }else {
            callValidatePromoAPI(tfPromoCode.text!)
        }
    }
    
    //MARK:- Webservices
    func callGetPromoListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.PROMO_CODE
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["stamp"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.lblNoPromo.isHidden = true
                    self.cvPromoCode.isHidden = false
                    
                    self.arrPromoList = data
                    self.cvPromoCode.reloadData()
                }else{
                    self.lblNoPromo.isHidden = false
                    self.cvPromoCode.isHidden = true
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callValidatePromoAPI(_ promo:String) {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VALIDATE_PROMO
        
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "promo":promo
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        print(jsonObject)
                        UserModel.sharedInstance().selectedPromoCode = self.tfPromoCode.text!
                        UserModel.sharedInstance().synchroniseData()
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.showAlertView(jsonObject["message"] as? String)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
}

extension PromoCodeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPromoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableCell", for: indexPath) as! AvailableCell
        
        if let promoType = arrPromoList[indexPath.row]["type"] as? String, promoType == "Mini7" {
            cell.lblPromoMsg.text = "$7 off a wash!"
        }else{
            cell.lblPromoMsg.text = "$3 off a wash!"
        }
        
        if let expireAt = arrPromoList[indexPath.row]["expired_at"] as? String, expireAt != "" {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let convertedDate = df.date(from: expireAt)
            df.dateFormat = "dd MMM yyyy"
            let strDate = df.string(from: convertedDate!)
            cell.lblValidity.text = "Valid till \(strDate)"
        }
        
        cell.btnUse.tag = indexPath.row
        cell.btnUse.addTarget(self, action: #selector(btnUse_Action), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.cvPromoCode.frame.size.width / 2 - 15, height: 200)
        
    }
}
