//
//  BookingDetail_WasherVC.swift
//  Swipe
//
//  Created by My Mac on 30/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ConfWasherBookingVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var rightSwipe: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vwMore: UIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var vwCancel: CustomUIView!
    //@IBOutlet var vwNote: CustomUIView!
    @IBOutlet var vwStartJob: CustomUIView!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblPlateNo: UILabel!
    @IBOutlet weak var lblVehicleType: CustomLabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tvNotes: CustomTextView!
    
    @IBOutlet weak var vwCancelJob: UIView!
    
    @IBOutlet weak var lblConfirmationMsg: UILabel!
    
    @IBOutlet weak var lblChatIndicator: CustomLabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet var vwAlert: CustomUIView!
    //MARK:- Global Variables
    let locationManager = CLLocationManager()
    var flag = false
    var locationName = "", username = "", notes = "", vehicleName = "", plateNo = "", vehicleType = "", price = "", status = "", washID = "", user_id = "", endTime = "", startTime = ""
    var latitude = 0.0, longitude = 0.0, unreadCnt = 0
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.addSubview(vwAlert)
        self.vwAlert.frame.size.width = self.view.frame.size.width - 20
        self.vwAlert.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        self.vwAlert.isHidden = true

        self.view.addSubview(vwCancel)
        self.vwCancel.frame.size.width = self.view.frame.size.width - 20
        self.vwCancel.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        self.view.addSubview(vwMore)
        self.vwMore.frame.size.width = self.view.frame.size.width - 20
        self.vwMore.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
//        self.view.addSubview(vwNote)
//        self.vwNote.frame.size.width = self.view.frame.size.width - 20
//        self.vwNote.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        self.view.addSubview(vwStartJob)
        self.vwStartJob.frame.size.width = self.view.frame.size.width - 20
        self.vwStartJob.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        
        self.vwMore.isHidden = true
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        btnSwipe.layer.cornerRadius = 10
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
        self.rightSwipe.addGestureRecognizer(swipeRight)
        
        let blurView_action = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        self.blurView.addGestureRecognizer(blurView_action)
        
        setData()
    }
    
    //MARK:- Other Methods
    func setData() {
        lblLocation.text = locationName
        lblUsername.text = username
        lblNotes.text = notes
        lblVehicleName.text = vehicleName
        lblPlateNo.text = plateNo
        lblVehicleType.text = vehicleType
        lblPrice.text = price
        tvNotes.text = notes
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(15))
        let marker = GMSMarker(position: CLLocationCoordinate2DMake(latitude,longitude))
        marker.map = mapView
        
        if status == "Started" {
            vwCancelJob.isHidden = true
            btnSwipe.setTitle("SWIPE TO END", for: .normal)
        }else {
            vwCancelJob.isHidden = false
            btnSwipe.setTitle("SWIPE TO START", for: .normal)
            callIsWashStarted()
        }
        
        if unreadCnt == 0 {
            lblChatIndicator.isHidden = true
        }else {
            lblChatIndicator.isHidden = false
        }
        
        let df = DateFormatter()
        df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(abbreviation: "UTC")
        let parsedStartDate = df.date(from: startTime)
        let parsedEndDate = df.date(from: endTime)
        
        df.dateFormat = "hh:mm a"
        df.timeZone = TimeZone.current
        let convertedEndTime = df.string(from: parsedEndDate!)
        
        let sameDay = Calendar.current.isDate(parsedStartDate!, inSameDayAs: parsedEndDate!)
        if sameDay {
            lblEndTime.text = "Today, \(convertedEndTime)"
        }else {
            lblEndTime.text = "Tomorrow, \(convertedEndTime)"
        }
    }
    
    //MARK:- Selector Methods
    @objc func blurViewTapped(gestureRecognizer: UITapGestureRecognizer){
        
        self.blurView.isHidden = true
        self.rightSwipe.isHidden = false
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = true
        //self.vwNote.isHidden = true
        self.vwStartJob.isHidden = true
        self.vwAlert.isHidden = true
        
    }
    
    @objc func Swiped(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) && !flag {
            
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.x)
            
            if(gestureRecognizer.view!.center.x < btnSwipe.frame.width) && !flag{
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x  + translation.x, y: gestureRecognizer.view!.center.y)
                print("moving")
            }else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y:gestureRecognizer.view!.center.y)
                print("reached")
                flag = true
                
                self.btnSwipe.layer.cornerRadius = 10
                
                if self.status == "Accepted" {
                    self.lblConfirmationMsg.text = "Ready to start job?"
                }else {
                    self.lblConfirmationMsg.text = "Proceed to phototaking of vehicle to end the job ?"
                }
                
                self.vwStartJob.isHidden = false
                self.blurView.isHidden = false
                

            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func btnMore_ACtion(_ sender: Any) {
        self.vwMore.isHidden = false
        self.blurView.isHidden = false
    }
    
    @IBAction func btnClose_More_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = true
        //self.vwNote.isHidden = true
        self.blurView.isHidden = true
    }
    
    @IBAction func btnCancelJob_Confirmation_Action(_ sender: Any) {
        self.vwStartJob.isHidden = true
        self.blurView.isHidden = true
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        if UserModel.sharedInstance().started_Booking_id == nil{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.vwAlert.isHidden = false
            self.blurView.isHidden = false
        }
    }
    
    @IBAction func btnClose_Alert_Action(_ sender: Any) {
        self.vwAlert.isHidden = true
        self.blurView.isHidden = true
    }
    
    @IBAction func btnCancelJob_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = false
    }
    
    @IBAction func btnChat_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.blurView.isHidden = true
        unreadCnt = 0
        lblChatIndicator.isHidden = true
        self.performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    @IBAction func btnNote_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        //self.vwNote.isHidden = false
    }
    
    @IBAction func btnVehicleMud_Action(_ sender: Any) {
        self.blurView.isHidden = true
        self.vwCancel.isHidden = true
        self.performSegue(withIdentifier: "toPhoto", sender: "cakemud")
    }
    
    @IBAction func btnUnableToLocate_Action(_ sender: UIButton) {
        self.vwCancel.isHidden = true
        callCancelWashAPI()
    }
    
    @IBAction func btnConfirmJob_Action(_ sender: CustomButton) {
        self.vwStartJob.isHidden = true
        self.blurView.isHidden = true
        
        if status == "Accepted" {
            callStartJobAPI()
        }else {
            self.performSegue(withIdentifier: "toPhoto", sender: "complete")
        }
        
    }
    
    //MARK:- Webservices
    
    func callIsWashStarted() {
        //washer_reward_data
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.IS_WASH_STARTED
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int, status == 200 {
                    
                    if let data = jsonObject["wash"] as? Int{
                        if data == 0{
                            self.btnSwipe.backgroundColor = AppColors.cyan
                            self.btnSwipe.isUserInteractionEnabled = true
                            self.rightSwipe.isUserInteractionEnabled = true
                        }else{
                            self.btnSwipe.backgroundColor = UIColor.lightGray
                            self.btnSwipe.isUserInteractionEnabled = false
                            self.rightSwipe.isUserInteractionEnabled = false
                        }
                    }else{
                        self.btnSwipe.backgroundColor = UIColor.lightGray
                        self.btnSwipe.isUserInteractionEnabled = false
                        self.rightSwipe.isUserInteractionEnabled = false
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callCancelWashAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.CANCEL_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "wash_id": washID
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
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
    
    func callStartJobAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.START_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "wash_id": washID
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
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
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto"{
            let vc = segue.destination as! VehiclePhotoSubmissionVC
            vc.isComeFrom = sender as! String
            vc.washID = self.washID
        }else if segue.identifier == "toChat"{
            let vc = segue.destination as! ChatWashVC
            vc.booking_id = washID
            vc.custName = username
            vc.cust_id = user_id
        }
    }
    
}

