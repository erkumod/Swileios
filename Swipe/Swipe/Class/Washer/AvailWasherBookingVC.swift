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
    
    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var rightSwipe: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vwConfirm: CustomUIView!
    @IBOutlet weak var blurView: UIImageView!
    
    @IBOutlet var vwRedeemAlert: CustomUIView!
    
    let locationManager = CLLocationManager()
    var flag = false
    
    
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
                self.rightSwipe.isHidden = true
                self.rightSwipe.center = CGPoint(x: 35 , y: gestureRecognizer.view!.center.y)
                
                self.vwConfirm.isHidden = false
                self.blurView.isHidden = false
                self.btnSwipe.layer.cornerRadius = 10
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.vwConfirm.isHidden = true
                    self.blurView.isHidden = true
                }
                
                
            }
        }
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOkRedeemAlert_Action(_ sender: Any) {
        self.vwRedeemAlert.isHidden = true
        self.blurView.isHidden = true
    }
    
    func add_Pin(_ lat : Double , _ lng : Double){
        let position = CLLocationCoordinate2DMake(lat,lng)
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto"{
            let vc = segue.destination as! VehiclePhotoSubmissionVC
            vc.isComeFrom = sender as! String
        }
    }
    
}

extension AvailWasherBookingVC: CLLocationManagerDelegate {
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
        add_Pin(center.latitude, center.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}
