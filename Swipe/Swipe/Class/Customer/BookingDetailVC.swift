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

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var vwPopup: CustomUIView!
    
    @IBOutlet weak var consBeforeAccept: NSLayoutConstraint!
    @IBOutlet weak var consAfterAccept: NSLayoutConstraint!
    @IBOutlet weak var btnWasher: CustomButton!
    
    let locationManager = CLLocationManager()
    var bookingStatus = "accept"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        self.vwPopup.isHidden = true
        self.blurView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bookingStatus == "accept"{
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
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelBooking_Action(_ sender: Any) {
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
    }
    
    func add_Pin(_ lat : Double , _ lng : Double){
        let position = CLLocationCoordinate2DMake(lat,lng)
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }


}
extension BookingDetailVC: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: center.latitude,
                                              longitude: center.longitude,
                                              zoom: Float(15))
        
        mapView.camera = camera
        //getAddress(lat: center.latitude, long: center.longitude)
        add_Pin(center.latitude, center.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}
