//
//  HomeVC.swift
//  Swipe
//
//  Created by My Mac on 15/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class HomeVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tfSource: UITextField!
    @IBOutlet weak var vwBooking: CustomUIView!
    @IBOutlet weak var vwNotes: UIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var ivRightSwipe: UIImageView!
    @IBOutlet weak var btnSwipe: UIButton!
    
    let locationManager = CLLocationManager()
    var flag = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSwipe.layer.cornerRadius = 10
        blurView.isHidden = true
        vwNotes.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let padding = UIEdgeInsets(top:0, left: 5, bottom: 305, right: 5)
        mapView.padding = padding
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
        self.ivRightSwipe.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
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
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            
            let statusbarView = UIView(frame: app.statusBarFrame)
            statusbarView.backgroundColor = AppColors.cyan
            app.statusBarUIView?.addSubview(statusbarView)
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColors.cyan
        }
    }
    
    @IBAction func btnSideMenu_Action(_ sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        blurView.isHidden = true
        vwNotes.isHidden = true
    }
    
    @IBAction func btnSubmitNote_Action(_ sender: Any) {
        blurView.isHidden = true
        vwNotes.isHidden = true
    }
    
    @IBAction func btnNote_ACtion(_ sender: Any) {
        blurView.isHidden = false
        vwNotes.isHidden = false
    }
    
    @IBAction func btnPromo_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toPromo", sender: nil)
    }
    
    @IBAction func btnCard_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toWallet", sender: "Home")
    }
    
    //MARK:- Other Function
    func configureLocationServices() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWallet"{
            let vc = segue.destination as! WalletVC
            vc.comeFrom = sender as! String
        }
    }
    
    func getAddress(lat : Double , long : Double) {
        let geoCoder = CLGeocoder()
        tfSource.text = ""
        var address = ""
        let loc: CLLocation = CLLocation(latitude:lat, longitude: long)
        
        geoCoder.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")}
                if let pm = placemarks as? [CLPlacemark]{
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        let addressString : String = ""
                        if pm.subLocality != nil {
                            address = address + pm.subLocality! + ", "}
                        if pm.thoroughfare != nil {
                            address = address + pm.thoroughfare! + ", "}
                        if pm.locality != nil {
                            address = address + pm.locality! + ", "}
                        if pm.country != nil {
                            address = address + pm.country!
                        }
                        self.tfSource.text = address
                      
                        print(addressString)
                    }
                }
        })
    }
    
    func add_Pin(_ lat : Double , _ lng : Double){
        let position = CLLocationCoordinate2DMake(lat,lng)
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }
    
    //MARK:- Web Service Calling
    
}
extension HomeVC: CLLocationManagerDelegate {
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
        getAddress(lat: center.latitude, long: center.longitude)
        add_Pin(center.latitude, center.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}
