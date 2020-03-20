//
//  RedemptionVC.swift
//  Swipe
//
//  Created by My Mac on 02/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import CoreLocation

class RedemptionVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var iv78: UIImageView!
    @IBOutlet weak var iv89: UIImageView!
    @IBOutlet weak var iv910: UIImageView!
    
    @IBOutlet weak var tfUnitNumber: CustomTextField!
    @IBOutlet weak var tfPostalCode: CustomTextField!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSep1: UILabel!
    @IBOutlet weak var lblSep2: UILabel!
    
    //MARK:- Global Variables
    var address = ""
    var deliveryTime = "7:00 PM - 8:00 PM"
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocationFromPostalCode(postalCode: "520866")
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn78_Action(_ sender: Any) {
        iv78.image = UIImage(named: "correct")
        iv89.image = nil
        iv910.image = nil
        deliveryTime = "7:00 PM - 8:00 PM"
    }
    
    @IBAction func btn89_Action(_ sender: Any) {
        iv78.image = nil
        iv89.image = UIImage(named: "correct")
        iv910.image = nil
        deliveryTime = "8:00 PM - 9:00 PM"
    }
    
    @IBAction func btn910_Action(_ sender: Any) {
        iv78.image = nil
        iv89.image = nil
        iv910.image = UIImage(named: "correct")
        deliveryTime = "9:00 PM - 10:00 PM"
    }
    
    @IBAction func btnSearch_Action(_ sender: CustomButton) {
        if tfPostalCode.text! != "" {
            getLocationFromPostalCode(postalCode: tfPostalCode.text!)
        }else {
            self.showAlertView("Please provider postal code")
        }
    }
    
    @IBAction func btnSubmit_Action(_ sender: CustomButton) {
        if tfPostalCode.text! == "" {
            self.showAlertView("Please provide postal code")
        }else if address == "" {
            self.showAlertView("Please provide valid postal code")
        }else if tfUnitNumber.text! == "" {
            self.showAlertView("Please provide valid unit number")
        }else if deliveryTime == "" {
            self.showAlertView("Please select delivery time")
        }else {
            callRedeemWasherReward()
        }
    }
    
    
    //MARK:- Other Methods
    func getLocationFromPostalCode(postalCode : String){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(postalCode) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of type CLPlacemarks, first item in array is best guess of Address
            
            if let placemark = placemarks?[0] {
                
                if placemark.postalCode == postalCode{
                    self.lblAddress.text = placemark.compactAddress!
                    self.address = placemark.compactAddress!
                    self.lblSep1.text = ""
                    self.lblSep2.text = ""
                }
                else{
                    self.lblAddress.text = "Auto populate"
                    self.lblSep1.text = "--------------------------------------------------------"
                    self.lblSep2.text = "--------------------------------------------------------"
                    print("Please enter valid zipcode")
                }
            }
        }
    }
    
    //MARK:- Webservices
    func callRedeemWasherReward() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.REDEEM_WASHER_REWARD
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!,
                                           "delivery_time": deliveryTime, "postal_code": tfPostalCode.text!, "unit_number": tfUnitNumber.text!, "address": address]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }) { (error) in
            print(error)
        }
    }
}
