//
//  RewardVC.swift
//  Swipe
//
//  Created by My Mac on 25/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RedemptionCell : UICollectionViewCell{
    
    @IBOutlet weak var lblOff: CustomLabel!
    @IBOutlet weak var ivPic: CustomImageView!
}

class AvailableCell : UICollectionViewCell{
    @IBOutlet weak var lblPromoMsg: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    
    @IBOutlet weak var btnUse: CustomButton!
}

class HistoryCell : UICollectionViewCell{
    
    @IBOutlet weak var lblPromoMsg: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
}

class RewardVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var consWidthScreen: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var cvRedemption: UICollectionView!
    @IBOutlet weak var cvAvailable: UICollectionView!
    @IBOutlet weak var cvHistory: UICollectionView!
    
    @IBOutlet weak var btnRedemption: UIButton!
    @IBOutlet weak var btnAvailable: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblRedemBtm: UILabel!
    @IBOutlet weak var lblAvailBtm: UILabel!
    @IBOutlet weak var lblHistoryBtm: UILabel!
    
    @IBOutlet weak var btnRedeem: CustomButton!
    @IBOutlet weak var lblTerms: UILabel!
    
    
    //MARK:- Global Variables
    var arrPromoList = [[String:AnyObject]]()
    var arrPromoHistoryList = [[String:AnyObject]]()
    var booking_count = 0
    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consWidthScreen.constant = self.view.frame.size.width
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        btnRedemption.setTitleColor(AppColors.cyan, for: .normal)
        btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblRedemBtm.isHidden = false
        lblAvailBtm.isHidden = true
        lblHistoryBtm.isHidden = true
        callGetRedemptionAPI()
    }
    
    //MARK:- Button Actions
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnRedemption_Action(_ sender: Any) {
        callGetRedemptionAPI()
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    @IBAction func btnAvailable_Action(_ sender: Any) {
        callGetPromoListAPI()
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width, y:0), animated: true)
    }
    
    @IBAction func btnHistory_Action(_ sender: Any) {
        callGetPromoHistoryListAPI()
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width + self.view.frame.size.width , y:0), animated: true)
    }
    
    @objc func btnUse_Action(_ sender:UIButton) {
        UserModel.sharedInstance().selectedPromoType = arrPromoList[sender.tag]["type"] as? String
        UserModel.sharedInstance().selectedPromoCode = arrPromoList[sender.tag]["code"] as? String
        UserModel.sharedInstance().synchroniseData()
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnRedeem_Action(_ sender: CustomButton) {
        print("Redemption Clicked")
        callRedeemStampAPI()
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
                    
                    self.arrPromoList = data
                    self.cvAvailable.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetPromoHistoryListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.PROMO_HISTORY
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["stamp"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    
                    self.arrPromoHistoryList = data
                    self.cvHistory.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetRedemptionAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.USER_REWARDS_REDEEM
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let bookingCnt = jsonObject["booking_count"] as? Int {
                        self.booking_count = bookingCnt
                        self.cvRedemption.reloadData()
                        
                        if self.booking_count >= 4 {
                            self.btnRedeem.isUserInteractionEnabled = true
                            self.btnRedeem.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
                        }else {
                            self.btnRedeem.isUserInteractionEnabled = false
                            self.btnRedeem.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
                        }
                        
                    }
                    
                    if let terms = jsonObject["terms"] as? [String] {
                        print(terms)
                        let strTerms = terms.joined(separator: "\n")
                        self.lblTerms.text = strTerms
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callRedeemStampAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.USER_STAMP_REDEEM
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                self.callGetRedemptionAPI()
                CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
            }
        }) { (error) in
            print(error)
        }
        
    }
    
}
extension RewardVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page_Number = round(scrView.contentOffset.x / scrView.frame.size.width)
        print(page_Number)
        if page_Number == 0.0 {
            btnRedemption.setTitleColor(AppColors.cyan, for: .normal)
            btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
            btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
            lblRedemBtm.isHidden = false
            lblAvailBtm.isHidden = true
            lblHistoryBtm.isHidden = true
        }else if page_Number == 1.0 {
            btnRedemption.setTitleColor(UIColor.lightGray, for: .normal)
            btnAvailable.setTitleColor(AppColors.cyan, for: .normal)
            btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
            lblRedemBtm.isHidden = true
            lblAvailBtm.isHidden = false
            lblHistoryBtm.isHidden = true
        }else if page_Number == 2.0 {
            btnRedemption.setTitleColor(UIColor.lightGray, for: .normal)
            btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
            btnHistory.setTitleColor(AppColors.cyan, for: .normal)
            lblRedemBtm.isHidden = true
            lblAvailBtm.isHidden = true
            lblHistoryBtm.isHidden = false
        }
    }
}

extension RewardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvRedemption{
            return 10
        }else if collectionView == cvAvailable{
            return arrPromoList.count
        }else{
            return arrPromoHistoryList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvRedemption{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RedemptionCell", for: indexPath) as! RedemptionCell
            
            if indexPath.row == 4 || indexPath.row == 9{
                cell.lblOff.isHidden = false
                cell.ivPic.isHidden = true
                
                if indexPath.row == 4 {
                    cell.lblOff.text = "$3\nOFF"
                    if booking_count >= 4 {
                        cell.lblOff.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0)
                    }else {
                        cell.lblOff.backgroundColor = UIColor.white
                    }
                }else {
                    cell.lblOff.text = "$7\nOFF"
                    if booking_count >= 8 {
                        cell.lblOff.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0)
                    }else {
                        cell.lblOff.backgroundColor = UIColor.white
                    }
                }
                
            }else {
                if indexPath.row >= 4 {
                    if booking_count >= indexPath.row {
                        cell.ivPic.image = UIImage(named : "app_icon_blue_bg")
                    }else {
                        cell.ivPic.image = UIImage(named : "graycar")
                    }
                }else {
                    if booking_count >= indexPath.row + 1 {
                        cell.ivPic.image = UIImage(named : "app_icon_blue_bg")
                    }else {
                        cell.ivPic.image = UIImage(named : "graycar")
                    }
                }
                
                cell.lblOff.isHidden = true
                cell.ivPic.isHidden = false
            }
            
            return cell
            
        }else if collectionView == cvAvailable{
            
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
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            
            if let promoCde = arrPromoHistoryList[indexPath.row]["code"] as? String {
                cell.lblPromoMsg.text = promoCde
            }else{
                cell.lblPromoMsg.text = ""
            }
            
            if let updatedAt = arrPromoHistoryList[indexPath.row]["updated_at"] as? String, updatedAt != "" {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let convertedDate = df.date(from: updatedAt)
                df.dateFormat = "dd MMM yyyy"
                let strDate = df.string(from: convertedDate!)
                cell.lblValidity.text = "Used on \(strDate)"
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvRedemption{
            return CGSize(width: self.cvRedemption.frame.size.width / 5, height: self.cvRedemption.frame.size.width / 5)
        }else if collectionView == cvAvailable{
            return CGSize(width: self.cvAvailable.frame.size.width / 2 - 15, height: 200)
        }else{
            return CGSize(width: self.cvHistory.frame.size.width / 2 - 15, height: 200)
        }
        
    }
    
    
    
    
}
