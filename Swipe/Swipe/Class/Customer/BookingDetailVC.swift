//
//  BookingDetailVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class BookingDetailVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var vwPopup: CustomUIView!
    
    @IBOutlet weak var consBeforeAccept: NSLayoutConstraint!
    @IBOutlet weak var consAfterAccept: NSLayoutConstraint!
    @IBOutlet weak var btnWasher: CustomButton!
    
    @IBOutlet weak var lblPendingVehicleName: UILabel!
    @IBOutlet weak var lblPendingTime: UILabel!
    @IBOutlet weak var lblPendingType: CustomLabel!
    @IBOutlet weak var lblPendingAddress: UILabel!
    @IBOutlet weak var lblPendingPrice: UILabel!
    
    @IBOutlet weak var lblAcceptedVehicleName: UILabel!
    @IBOutlet weak var lblAcceptedType: CustomLabel!
    
    @IBOutlet weak var lblAcceptedTime: UILabel!
    
    @IBOutlet weak var lblAcceptedPrice: UILabel!
    @IBOutlet weak var lblAcceptedAddress: UILabel!
    
    @IBOutlet weak var imgAcceptedLine: UIImageView!
    @IBOutlet weak var imgInProgressLine: UIImageView!
    @IBOutlet weak var imgAccepted: CustomImageView!
    @IBOutlet weak var imgInProgress: CustomImageView!
    @IBOutlet weak var imgCompleted: CustomImageView!
    
    @IBOutlet weak var imgWasherProfile: CustomImageView!
    @IBOutlet weak var lblWasherName: UILabel!
    @IBOutlet weak var lblWasherUpCnt: UILabel!
    @IBOutlet weak var lblWasherDownCnt: UILabel!
    
    @IBOutlet weak var btnPendingCancelBooking: CustomButton!
    @IBOutlet weak var btnAcceptedCancelBooking: CustomButton!
    
    
    @IBOutlet weak var lblChatIndicator: CustomLabel!
    
    //MARK:- Global Variables
    var isPromo = false
    var washID = "", bookingStatus = "Accepted", bookingStartDate = "", bookingEndDate = "", vehicleName = "", vehicleType = "", address = "", promocode = "", farePrice = "", washerProfile = "", washerName = "", latitude = "", longitude = "", washerUpVoteCnt = 0, washerDownVoteCnt = 0, booking_Id = "", unreadCnt = 0
    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        self.vwPopup.isHidden = true
        self.blurView.isHidden = true
        
        if unreadCnt == 0 {
            lblChatIndicator.isHidden = true
        }else {
            lblChatIndicator.isHidden = false
        }
        
        if bookingStartDate != "", bookingEndDate != "" {
            let df = DateFormatter()
            df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(abbreviation: "UTC")
            let parsedStartDate = df.date(from: bookingStartDate)
            let parsedEndDate = df.date(from: bookingEndDate)
            
            df.dateFormat = "hh:mm a"
            df.timeZone = TimeZone.current
            let convertedStartTime = df.string(from: parsedStartDate!)
            let convertedEndTime = df.string(from: parsedEndDate!)
            
            let sameDay = Calendar.current.isDate(parsedStartDate!, inSameDayAs: parsedEndDate!)
            if sameDay {
                lblPendingTime.text = "Today, \(convertedStartTime) - \nToday, \(convertedEndTime)"
                lblAcceptedTime.text = "Today, \(convertedStartTime) - \nToday, \(convertedEndTime)"
            }else {
                lblPendingTime.text = "Today, \(convertedStartTime) - \nTomorrow, \(convertedEndTime)"
                lblAcceptedTime.text = "Today, \(convertedStartTime) - \nTomorrow, \(convertedEndTime)"
            }
        }
        
        lblPendingVehicleName.text = vehicleName
        lblAcceptedVehicleName.text = vehicleName
        
        lblPendingType.text = vehicleType
        lblAcceptedType.text = vehicleType
                
        lblPendingAddress.text = address
        lblAcceptedAddress.text = address
        
        lblPendingPrice.text = String(format: "%.2f", Double(farePrice)!)
        lblAcceptedPrice.text = String(format: "%.2f", Double(farePrice)!)
        
        if latitude != "" && longitude != "" {
            add_Pin(Double(latitude)!, Double(longitude)!)
        }
        
        if bookingStatus == "Accepted" || bookingStatus == "Started" {
            lblWasherUpCnt.text = "\(washerUpVoteCnt)"
            lblWasherDownCnt.text = "\(washerDownVoteCnt)"
            lblWasherName.text = washerName
            
            imgWasherProfile.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(washerProfile)"))
        }
        
        if bookingStatus == "Accepted" {
            imgAccepted.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
            
            imgInProgress.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            imgInProgressLine.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            
            imgCompleted.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            imgAcceptedLine.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            
            btnAcceptedCancelBooking.isHidden = false
            
        }else if bookingStatus == "Started" {
            imgAccepted.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
            imgInProgress.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
            
            imgAcceptedLine.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
            
            imgInProgressLine.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            imgCompleted.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            
            btnAcceptedCancelBooking.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bookingStatus == "Accepted" || bookingStatus == "Started"{
            let padding = UIEdgeInsets(top:0, left: 20, bottom: 412, right: 15)
            mapView.padding = padding
            consAfterAccept.constant = 400
            consBeforeAccept.constant = 0
            btnWasher.isHidden = false
        }else{
            let padding = UIEdgeInsets(top:0, left: 20, bottom: 315, right: 15)
            mapView.padding = padding
            consBeforeAccept.constant = 305
            consAfterAccept.constant = 0
            btnWasher.isHidden = true
        }
    }
    
    //MARK:- Other Methods
    func add_Pin(_ lat : Double , _ lng : Double){
        mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: Float(15))
        let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat,lng))
        marker.map = mapView
    }

    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPendingCancelBooking_Action(_ sender: CustomButton) {
        self.vwPopup.isHidden = false
        self.blurView.isHidden = false
    }
    
    @IBAction func btnPopupCancelBooking_Action(_ sender: Any) {
        self.vwPopup.isHidden = true
        self.blurView.isHidden = true
    }
    
    @IBAction func btnPopupConfirmBooking_Action(_ sender: Any) {
        self.vwPopup.isHidden = true
        self.blurView.isHidden = true
        
        callCancelBookingAPI()
    }
    
    @IBAction func btnAcceptedCancelBooking_Action(_ sender: CustomButton) {
        self.vwPopup.isHidden = false
        self.blurView.isHidden = false
    }
    
    @IBAction func btnChat_Action(_ sender: Any) {
        unreadCnt = 0
        lblChatIndicator.isHidden = true
        self.performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat"{
           let vc = segue.destination as! ChatCustVC
            vc.booking_id = booking_Id
            vc.washer_id = washID
            vc.washerName = washerName
        }
    }
    
    //MARK:- Webservices
    func callCancelBookingAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.CANCEL_CAR_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "wash_id": washID
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
}
