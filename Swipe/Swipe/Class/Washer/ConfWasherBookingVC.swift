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

    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var rightSwipe: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vwMore: UIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var vwCancel: CustomUIView!
    @IBOutlet var vwNote: CustomUIView!
    @IBOutlet var vwStartJob: CustomUIView!
    
    let locationManager = CLLocationManager()
    var flag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(vwCancel)
        self.vwCancel.frame.size.width = self.view.frame.size.width - 20
        self.vwCancel.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        self.view.addSubview(vwMore)
        self.vwMore.frame.size.width = self.view.frame.size.width - 20
        self.vwMore.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
        self.view.addSubview(vwNote)
        self.vwNote.frame.size.width = self.view.frame.size.width - 20
        self.vwNote.frame = CGRect(x: 15, y: self.view.frame.size.height - 220, width: self.view.frame.size.width - 30, height: 181)
        
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
        
    }
    
    @objc func blurViewTapped(gestureRecognizer: UITapGestureRecognizer){
        
        self.blurView.isHidden = true
        self.rightSwipe.isHidden = false
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = true
        self.vwNote.isHidden = true
        self.vwStartJob.isHidden = true
        
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
                self.vwStartJob.isHidden = false
                self.blurView.isHidden = false

            }
        }
    }
    
    @IBAction func btnMore_ACtion(_ sender: Any) {
        self.vwMore.isHidden = false
        self.blurView.isHidden = false
    }
    
    @IBAction func btnClose_More_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = true
        self.vwNote.isHidden = true
        self.blurView.isHidden = true
    }
    
    @IBAction func btnCancelJob_Confirmation_Action(_ sender: Any) {
        self.vwStartJob.isHidden = true
        self.blurView.isHidden = true
    }
    
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelJob_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.vwCancel.isHidden = false
    }
    
    @IBAction func btnChat_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    @IBAction func btnNote_Action(_ sender: Any) {
        self.vwMore.isHidden = true
        self.vwNote.isHidden = false
    }
    
    @IBAction func btnVehicleMud_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toPhoto", sender: "cakemud")
    }
    func configureLocationServices() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
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

extension ConfWasherBookingVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
