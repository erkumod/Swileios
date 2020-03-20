//
//  SwipeBoxDetailVC.swift
//  Swipe
//
//  Created by My Mac on 12/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class SwipeBoxDetailVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblJobID: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblNetEarning: UILabel!
    
    //MARK:- Global Variables
    var washID = 0
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        callWashDetail()
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Webservices
    func callWashDetail() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_DETAIL
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "wash_id": "\(washID)"]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let dictBooking = jsonObject["booking"] as? [String:AnyObject] {
                        if let location = dictBooking["location"] as? String {
                            self.lblLocation.text = location
                        }
                        
                        if let start_time = dictBooking["start_time"] as? String {
                            
                            let df = DateFormatter()
                            df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                            df.locale = Locale(identifier: "en_US_POSIX")
                            df.timeZone = TimeZone(abbreviation: "UTC")
                            let parsedStartDate = df.date(from: start_time)
                            
                            df.dateFormat = "dd MMM yyyy"
                            df.timeZone = TimeZone.current
                            let convertedStartDate = df.string(from: parsedStartDate!)
                            
                            df.dateFormat = "hh:mm a"
                            let convertedStartTime = df.string(from: parsedStartDate!)
                            
                            self.lblDateTime.text = "\(convertedStartDate),\n\(convertedStartTime)"
                        }
                        
                        if let job_code = dictBooking["job_code"] as? String {
                            self.lblJobID.text = job_code
                        }
                        
                        if let type = dictBooking["type"] as? String {
                            self.lblServiceType.text = type
                        }
                        
                        if let fare = dictBooking["fare"] as? String {
                            self.lblServiceFee.text = String(format: "SGD %.2f", Double(fare)!)
                            self.lblNetEarning.text = String(format: "SGD %.2f", Double(fare)!)
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
}
