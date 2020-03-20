//
//  AvailWasherBookingVC.swift
//  Swipe
//
//  Created by My Mac on 09/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class AvailWasherBookingVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var rightSwipe: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vwConfirm: CustomUIView!
    @IBOutlet weak var blurView: UIImageView!
    
    @IBOutlet var vwRedeemAlert: CustomUIView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblVehicleType: CustomLabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    //MARK:- Global Variables
    let locationManager = CLLocationManager()
    var flag = false
    var locationName = "", username = "", vehicleType = "", price = "", washID = ""
    var latitude = 0.0, longitude = 0.0, distance = 0.0
    var total_washes = 0
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(vwConfirm)
        self.vwConfirm.frame.size.width = self.view.frame.size.width - 40
        self.vwConfirm.center = self.view.center
        
        self.view.addSubview(vwRedeemAlert)
        self.vwRedeemAlert.frame.size.width = self.view.frame.size.width - 40
        self.vwRedeemAlert.center = self.view.center
        
     
        self.vwConfirm.isHidden = true
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        btnSwipe.layer.cornerRadius = 10
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
        self.rightSwipe.addGestureRecognizer(swipeRight)
        
        setData()
        
        callGetWasherWashCount()
    }
    
    //MARK:- Other Methods
    func setData() {
        lblAddress.text = locationName
        lblUsername.text = username
        lblVehicleType.text = vehicleType
        lblPrice.text = price
        lblDistance.text = String (format: "%.2fKm away from your location", distance)
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Float(15))
        let marker = GMSMarker(position: CLLocationCoordinate2DMake(latitude,longitude))
        marker.map = mapView
    }
    
    //MARK:- Selector Methods
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
                self.rightSwipe.isHidden = true
                self.rightSwipe.center = CGPoint(x: 35 , y: gestureRecognizer.view!.center.y)
                
                if total_washes < 6 {
                    callAcceptWashAPI()
                }else {
                    self.vwRedeemAlert.isHidden = false
                    self.blurView.isHidden = false
                    self.btnSwipe.layer.cornerRadius = 10
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.vwRedeemAlert.isHidden = true
                        self.blurView.isHidden = true
                    }
                }
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOkRedeemAlert_Action(_ sender: Any) {
        self.vwRedeemAlert.isHidden = true
        self.blurView.isHidden = true
    }
    
    //MARK:- Webservices
    func callGetWasherWashCount() {
        //washer_reward_data
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_COUNT
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let completedCount = jsonObject["completed_wash_count"] as? Int {
                        self.total_washes = completedCount
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callAcceptWashAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.ACCEPT_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "wash_id": washID
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.vwConfirm.isHidden = false
                        self.blurView.isHidden = false
                        self.btnSwipe.layer.cornerRadius = 10
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.vwConfirm.isHidden = true
                            self.blurView.isHidden = true
                            self.navigationController?.popViewController(animated: true)
                        }
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
        }
    }
    
}

