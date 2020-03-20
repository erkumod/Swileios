//
//  BookingHistoryDetailVC.swift
//  Swipe
//
//  Created by My Mac on 12/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class BookingHistoryDetailVC: Main {

    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblBookingDate: UILabel!
    
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    
    @IBOutlet weak var lblAddress: CustomLabel!
    @IBOutlet weak var lblPromoCode: CustomLabel!
    
    @IBOutlet weak var lblFarePrice: UILabel!
    @IBOutlet weak var lblSepPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var imgWasherProfile: CustomImageView!
    @IBOutlet weak var lblWasherName: UILabel!
    
    @IBOutlet weak var imgVehicle1: UIImageView!
    @IBOutlet weak var imgVehicle2: UIImageView!
    
    @IBOutlet weak var imgUpVote: UIImageView!
    
    @IBOutlet weak var imgDownVote: UIImageView!
    
    @IBOutlet weak var lblBefore48HourDesc: UILabel!
    @IBOutlet weak var lblAfter48HourDesc: UILabel!
    var isPromo = false
    var washID = "", washerID = "", isRated = false, bookingID = "", bookingDate = "", vehicleName = "", vehicleType = "", address = "", promocode = "", farePrice = "", washerProfile = "", washerName = "", vehicle1 = "", vehicle2 = "", completeDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBookingData()
    }
    
    //MARK:- Other Methods
    func setBookingData() {
        lblBookingID.text = bookingID
        
        
        
        if bookingDate != "" {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(abbreviation: "UTC")
            let parsedEndDate = df.date(from: bookingDate)
            
            df.dateFormat = "dd MMM yyyy, hh:mm a"
            df.timeZone = TimeZone.current
            let convertedEndTime = df.string(from: parsedEndDate!)
            
            lblBookingDate.text = "\(convertedEndTime)"
        }
        
        lblVehicleName.text = vehicleName
        lblVehicleType.text = vehicleType
        lblAddress.text = address
        if isPromo {
            lblPromoCode.text = promocode
            lblPromoCode.isHidden = false
            lblTotalPrice.isHidden = false
            lblSepPrice.isHidden = false
        }else {
            lblPromoCode.text = ""
            lblPromoCode.isHidden = true
            lblTotalPrice.isHidden = true
            lblSepPrice.isHidden = true
        }
        lblFarePrice.text = farePrice
        
        if completeDate != "" {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt1 = df.date(from: completeDate)
            let date2 = Date()
            
            let hours = date2.hours(from: dt1!)
            let minutes = date2.minutes(from: dt1!)
            if hours == 48 && minutes > 0 {
                imgVehicle1.isHidden = true
                imgVehicle2.isHidden = true
                lblWasherName.isHidden = true
                lblBefore48HourDesc.isHidden = true
                imgUpVote.isHidden = true
                imgDownVote.isHidden = true
                
                lblAfter48HourDesc.isHidden = false
                
                imgWasherProfile.backgroundColor = UIColor.white
                
            }else if hours > 48 {
                imgVehicle1.isHidden = true
                imgVehicle2.isHidden = true
                lblWasherName.isHidden = true
                lblBefore48HourDesc.isHidden = true
                imgUpVote.isHidden = true
                imgDownVote.isHidden = true
                lblAfter48HourDesc.isHidden = false
                
                imgWasherProfile.backgroundColor = UIColor.white
                
            }else {
                lblBefore48HourDesc.isHidden = false
                lblAfter48HourDesc.isHidden = true
                
                lblWasherName.text = washerName
                
                if washerProfile != ""{
                    imgWasherProfile.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(washerProfile)"))
                }
                
                if vehicle1 != "" {
                    imgVehicle1.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(vehicle1)"))
                }
                
                if vehicle2 != "" {
                    imgVehicle2.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(vehicle2)"))
                }
            }
        }
        
        if !isRated {
            let tapUpVote = UITapGestureRecognizer(target: self, action: #selector(upVote_Action(_:)))
            imgUpVote.addGestureRecognizer(tapUpVote)
            
            let tapDownVote = UITapGestureRecognizer(target: self, action: #selector(downVote_Action(_:)))
            imgDownVote.addGestureRecognizer(tapDownVote)
        }
        
    }
    
    //MARK:- Selector Methods
    @objc func upVote_Action(_ sender:AnyObject) {
        callRateWashAPI("upvote")
    }
   
    @objc func downVote_Action(_ sender:AnyObject) {
        callRateWashAPI("downvote")
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Webservices
    func callRateWashAPI(_ type: String) {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.RATE_WASHER
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "washer_id": washerID,
            "type": type,
            "wash_id": washID
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.isRated = true
                        self.imgDownVote.isUserInteractionEnabled = false
                        self.imgUpVote.isUserInteractionEnabled = false
                        CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                    }else {
                        self.isRated = false
                        CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
}
