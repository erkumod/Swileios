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
import GooglePlaces

class HomeVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tfSource: UITextField!
    @IBOutlet weak var vwBooking: CustomUIView!
    @IBOutlet weak var vwNotes: UIView!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var ivRightSwipe: UIImageView!
    @IBOutlet weak var btnSwipe: UIButton!
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblPrimaryVehicle: UILabel!
    
//    @IBOutlet weak var lblToday: UILabel!
//    @IBOutlet weak var lblStartTime: UILabel!
    
//    @IBOutlet weak var lblTomorrow: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet weak var tvNotes: CustomTextView!
    @IBOutlet weak var lblPromo: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPriceStrike: UILabel!
    @IBOutlet weak var lblSGDPrice: UILabel!
    
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var vwConfPopup: CustomUIView!
    @IBOutlet weak var lblPopAddress: CustomLabel!
    @IBOutlet weak var lblPopCardNumber: UILabel!
    @IBOutlet weak var ivPopCard: CustomImageView!
    @IBOutlet weak var lblPopVehicle: UILabel!
    @IBOutlet weak var ivPopCarColor: CustomImageView!
    @IBOutlet weak var lblPopVehicleAvail: CustomLabel!
    @IBOutlet weak var lblPopEndtime: CustomLabel!
    @IBOutlet weak var lblPopCost: CustomLabel!
    
    //MARK:- Global Variables
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    var flag = false
    
    var selectedStartHour = "", selectedStartMin = "", selectedEndHour = "", selectedEndMin = "", startTime = "", endTime = "", startUTCDate = "", endUTCDate = "", farePrice = "20"
    var latitude = 0.0, longitude = 0.0, selectedHour = 1.0
    
    var vehicleID = ""
    var cardID = ""
    var promoCode = ""
    var addressLine = ""
    var strNotes = ""
    var bookingDate = ""
    
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
        //locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        

        
        
        
        let currentDate = Date()
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
//        self.lblEndTime.text = df.string(from: currentDate)
        //self.lblStartTime.text = df.string(from: currentDate)
        self.startTime = df.string(from: currentDate)
        self.endTime = df.string(from: currentDate)
        
        df.dateFormat = "HH"
        selectedStartHour = df.string(from: currentDate)
        selectedEndHour = "\(Int(selectedStartHour)! + 1)"
        df.dateFormat = "mm"
        selectedStartMin = df.string(from: currentDate)
        selectedEndMin = selectedStartMin
        
        setEndTime()
        
        setTodayTomorrow()
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
        
        self.ivRightSwipe.addGestureRecognizer(swipeRight)
        
        let blurViewTap = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        self.blurView.isUserInteractionEnabled = true
        self.blurView.addGestureRecognizer(blurViewTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData(notification:)), name: Notification.Name("profile_updated"), object: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if #available(iOS 13.0, *) {
//            let app = UIApplication.shared
//
//            let statusbarView = UIView(frame: app.statusBarFrame)
//            statusbarView.backgroundColor = AppColors.cyan
//            app.statusBarUIView?.addSubview(statusbarView)
//
//        } else {
//            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = AppColors.cyan
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetWashPriceAPI()
        (UIApplication.shared.delegate as! AppDelegate).callProfileInfoAPI()
//        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
        //(UIApplication.shared.delegate as! AppDelegate).callCheckWasherAPI()

        setStatusBarColor()
        
        if UserModel.sharedInstance().selectedPromoCode != nil && UserModel.sharedInstance().selectedPromoCode != "" {
        
            if  UserModel.sharedInstance().selectedPromoType != nil && UserModel.sharedInstance().selectedPromoType != "" {
                let padding = UIEdgeInsets(top:0, left: 5, bottom: 335, right: 5)
                mapView.padding = padding
                mapView.settings.myLocationButton = true
                mapView.isMyLocationEnabled = true
            }else{
                let padding = UIEdgeInsets(top:0, left: 5, bottom: 335, right: 5)
                mapView.padding = padding
                mapView.settings.myLocationButton = true
                mapView.isMyLocationEnabled = true
            }
        }else{
            let padding = UIEdgeInsets(top:0, left: 5, bottom: 310, right: 5)
            mapView.padding = padding
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
        }

        
    
    }
        
    //MARK:- Selector Methods
    @objc func setData(notification: Notification) {
        
        if UserModel.sharedInstance().selectedVehicleName != nil && UserModel.sharedInstance().selectedVehicleName != "" {
            lblPrimaryVehicle.text = UserModel.sharedInstance().selectedVehicleName!
            lblPopVehicle.text = UserModel.sharedInstance().selectedVehicleName!
        }else if UserModel.sharedInstance().primary_car != nil {
            let brand_name = UserModel.sharedInstance().primary_car!["car_brand_name"] as! String
            let model_name = UserModel.sharedInstance().primary_car!["car_model_name"] as! String
            let vehicleNo = UserModel.sharedInstance().primary_car!["vehicle_no"] as! String
            lblPrimaryVehicle.text = "\(brand_name) \(model_name) (\(vehicleNo))"
            lblPopVehicle.text = "\(brand_name) \(model_name) (\(vehicleNo))"
        }else {
            lblPrimaryVehicle.text = "Vehicle"
            lblPopVehicle.text = "Vehicle"
        }
        
        if UserModel.sharedInstance().selectedCardName != nil && UserModel.sharedInstance().selectedCardName != "" {
            let card_no = UserModel.sharedInstance().selectedCardName!
            lblCardNo.text = String(card_no.suffix(4))
            lblPopCardNumber.text = "**** **** **** "+String(card_no.suffix(4))
            
            if card_no.isVisaCard {
                imgCard.image = UIImage(named: "color_visa")
            }else if card_no.isMasterCard {
                imgCard.image = UIImage(named: "color_master")
            }else if card_no.isExpressCard {
                imgCard.image = UIImage(named: "color_american")
            }else if card_no.isDinerClubCard {
                imgCard.image = UIImage(named: "dinersclub")
            }else if card_no.isDiscoverCard {
                imgCard.image = UIImage(named: "discover")
            }else if card_no.isJCBCard {
                imgCard.image = UIImage(named: "jcb")
            }else {
                imgCard.image = UIImage(named: "default_card_new")
            }
            ivPopCard.image = imgCard.image
            
        } else if UserModel.sharedInstance().primary_card != nil {
            let card_no = UserModel.sharedInstance().primary_card!["card_no"] as! String
            lblCardNo.text = String(card_no.suffix(4))
            lblPopCardNumber.text = "**** **** **** "+String(card_no.suffix(4))
            if card_no.isVisaCard {
                imgCard.image = UIImage(named: "color_visa")
            }else if card_no.isMasterCard {
                imgCard.image = UIImage(named: "color_master")
            }else if card_no.isExpressCard {
                imgCard.image = UIImage(named: "color_american")
            }else if card_no.isDinerClubCard {
                imgCard.image = UIImage(named: "dinersclub")
            }else if card_no.isDiscoverCard {
                imgCard.image = UIImage(named: "discover")
            }else if card_no.isJCBCard {
                imgCard.image = UIImage(named: "jcb")
            }else {
                imgCard.image = UIImage(named: "default_card_new")
            }
            ivPopCard.image = imgCard.image
        } else {
            lblCardNo.text = "Card"
            lblPopCardNumber.text = "Card"
        }
    }
    
    func setPrice() {
        if UserModel.sharedInstance().selectedPromoCode != nil && UserModel.sharedInstance().selectedPromoCode != "" {
            
            if  UserModel.sharedInstance().selectedPromoType != nil && UserModel.sharedInstance().selectedPromoType != "" {
                if UserModel.sharedInstance().selectedPromoType == "Mini3"{
                    lblPromo.text = "$3 off"
                }else if UserModel.sharedInstance().selectedPromoType == "Mini7"{
                    lblPromo.text = "$7 off"
                }else{
                    lblPromo.text = UserModel.sharedInstance().selectedPromoCode!
                }
                
            }
            
            lblTotalPrice.isHidden = false
            lblSGDPrice.isHidden = false
            lblPriceStrike.isHidden = false
            
            lblTotalPrice.text = String(format: "%.2f", Double(farePrice)!)
            lblSGDPrice.text = "SGD"
            
            lblPopCost.text = "SGD" + lblTotalPrice.text!
            
            if UserModel.sharedInstance().selectedPromoType! == "Mini7" {
                let tempPrice = Int(farePrice)! - 7
                lblPrice.text = String(format: "%.2f", Double(tempPrice))
                farePrice = "\(tempPrice)"
                lblPopCost.text = "SGD" + String(format: "%.2f", Double(tempPrice))
            } else {
                let tempPrice = Int(farePrice)! - 3
                lblPrice.text = String(format: "%.2f", Double(tempPrice))
                farePrice = "\(tempPrice)"
                lblPopCost.text = "SGD" + String(format: "%.2f", Double(tempPrice))
            }
        }else {
            lblTotalPrice.isHidden = true
            lblSGDPrice.isHidden = true
            lblPriceStrike.isHidden = true
            
            lblTotalPrice.text = ""
            lblSGDPrice.text = ""
            lblPopCost.text = "SGD 20.00"
        }
    }
    @IBAction func btnCloseConfPop_Action(_ sender: Any) {
        self.blurView.isHidden = true
        self.vwConfPopup.isHidden = true
    }
    
    @IBAction func btnConfirmConfPop_Action(_ sender: Any) {

        if self.vehicleID == "" {
            flag = false
            CommonFunctions.shared.showToast(self.view, "Please select vehicle")
        }else if self.cardID == "" {
            flag = false
            CommonFunctions.shared.showToast(self.view, "Please select card")
        }else if self.addressLine == "" {
            flag = false
            CommonFunctions.shared.showToast(self.view, "Please select location")
        }else {
            flag = true
            callBookCarWashAPI(self.vehicleID, self.cardID, self.addressLine, self.strNotes, self.promoCode, self.bookingDate)
        }
        
        self.blurView.isHidden = true
        self.vwConfPopup.isHidden = true
        
    }
    
    @IBAction func btnSwipe_Action(_ sender: Any) {
        self.vwConfPopup.isHidden = false
        self.blurView.isHidden = false
        set_Booking()
    }
    
    @objc func blurViewTapped(gestureRecognizer: UITapGestureRecognizer) -> Void {
        self.vwConfPopup.isHidden = true
        self.blurView.isHidden = true
    }
    
    @objc func Swiped(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) && !flag {
            
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.x)
            
            if gestureRecognizer.view!.center.x <= 0{
                ivRightSwipe.center = CGPoint(x: 15 , y: gestureRecognizer.view!.center.y)
                return
            }
            
            if(gestureRecognizer.view!.center.x < btnSwipe.frame.width) && !flag{
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x  + translation.x, y: gestureRecognizer.view!.center.y)
                
                print("moving")
            }else {
                gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y:gestureRecognizer.view!.center.y)
                print("reached")
                flag = true
                self.vwConfPopup.isHidden = false
                self.blurView.isHidden = false
                set_Booking()
            }
        }
    }
    
    func set_Booking(){
        generateStartEndTimes()
       
        if UserModel.sharedInstance().selectedVehicleID != nil && UserModel.sharedInstance().selectedVehicleID != "" {
            self.vehicleID = UserModel.sharedInstance().selectedVehicleID!
        }else if UserModel.sharedInstance().primary_car != nil {
            self.vehicleID = "\(UserModel.sharedInstance().primary_car!["id"] as! Int)"
        }
        
       
        if UserModel.sharedInstance().selectedCardID != nil && UserModel.sharedInstance().selectedCardID != "" {
            self.cardID = UserModel.sharedInstance().selectedCardID!
        }else if UserModel.sharedInstance().primary_card != nil {
            self.cardID = "\(UserModel.sharedInstance().primary_card!["id"] as! Int)"
        }
        

        if UserModel.sharedInstance().selectedPromoCode != nil && UserModel.sharedInstance().selectedPromoCode != "" {
            self.promoCode = UserModel.sharedInstance().selectedPromoCode!
        }
        
        self.addressLine = self.tfSource.text!
        self.strNotes = self.tvNotes.text!
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        self.bookingDate = df.string(from: Date())
        
    }
    
    func setEndTime() {
        
        let arr = "\(selectedHour)".components(separatedBy: ".")
        if arr[1] == "0" {
            lblHour.text = "\(arr[0]) hr"
        }else {
            lblHour.text = "\(arr[0]) hr 30 min"
        }
        
        lblPopVehicleAvail.text = lblHour.text
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: Int(selectedHour * 60.0), to: Date())
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        endTime = df.string(from: date!)
        lblEndTime.text = df.string(from: date!)
        
        self.lblPopEndtime.text = lblEndTime.text//"\(lblEndTime.text!.split(separator: ":")[0])hr" + " \(lblEndTime.text!.split(separator: ":")[1].split(separator: " ")[0])min"
        
        df.dateFormat = "HH"
        self.selectedEndHour = df.string(from: date!)
        df.dateFormat = "mm"
        self.selectedEndMin = df.string(from: date!)
        
    }
    
    //MARK:- Button Actions
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
    
    @IBAction func btnPrimaryVehicle_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toVehicle", sender: "Home")
    }
    
    @IBAction func btnPromo_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toPromo", sender: nil)
    }
    
    @IBAction func btnCard_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toWallet", sender: "Home")
    }
    
    @IBAction func btnStartTime_Action(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Select Start Time", datePickerMode: .time, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            //self.lblStartTime.text = df.string(from: value!)
            self.startTime = df.string(from: value!)
            
            df.dateFormat = "HH"
            self.selectedStartHour = df.string(from: value!)
            df.dateFormat = "mm"
            self.selectedStartMin = df.string(from: value!)
            
            self.setTodayTomorrow()
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.show()
    }
    
    @IBAction func btnEndTime_Action(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Select End Time", datePickerMode: .time, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            self.lblEndTime.text = df.string(from: value!)
            self.endTime = df.string(from: value!)
            
            df.dateFormat = "HH"
            self.selectedEndHour = df.string(from: value!)
            df.dateFormat = "mm"
            self.selectedEndMin = df.string(from: value!)
            
            self.setTodayTomorrow()
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.show()
    }
    
    @IBAction func btnSelectVehicle_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toVehicle", sender: nil)
    }
    
    @IBAction func btnPlus_Action(_ sender: UIButton) {
        if selectedHour < 6.0 {
            selectedHour += 0.5
            btnMinus.isEnabled = true
        }else {
            btnPlus.isEnabled = false
        }
        
        setEndTime()
    }
    
    @IBAction func btnMinus_Action(_ sender: UIButton) {
        if selectedHour > 1 {
            selectedHour -= 0.5
            btnPlus.isEnabled = true
        }else {
            btnMinus.isEnabled = false
        }
        
        setEndTime()
    }
    
    //MARK:- UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfSource{
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    //MARK:- Other Functions
    func setTodayTomorrow() {
        if Int(self.selectedEndHour)! >= Int(self.selectedStartHour)! {
            //self.lblTomorrow.text = "Today"
        }else {
            //self.lblTomorrow.text = "Tomorrow"
        }
    }
    
    func checkStartEndTimings() -> Bool{
        let currentDate = Date()
        
        //get today & tomorrow dates
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        let todayDate = df.string(from: currentDate)
        var tomorrowDate = df.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
    
        if Int(selectedEndHour)! >= Int(selectedStartHour)! {
            tomorrowDate = todayDate
        }
        
        df.dateFormat = "dd-MM-yyyy hh:mm a"
        let date1 = df.date(from: todayDate + " " + startTime)!
        let date2 = df.date(from: tomorrowDate + " " + endTime)!
        
        let days = date2.days(from: date1)
        let hours = date2.hours(from: date1)
        let minutes = date2.minutes(from: date1)
        
        let startHours = date1.hours(from: currentDate)
        let startMins = date1.minutes(from: currentDate)
        
        if date1 < currentDate {
            CommonFunctions.shared.showToast(self.view, "Start time should be greater then current time")
            print("Start time should be greater then current time")
        }else if startHours == 0 && startMins <= 10 {
            CommonFunctions.shared.showToast(self.view, "Start time should be greater then 10 minutes from current time")
            print("Start time should be greater then 10 minutes from current time")
        }else if days > 0 {
            CommonFunctions.shared.showToast(self.view, "End time should not be more then 6 hours from start time")
            print("End time should not be more then 6 hours from start time")
        }else if date2 < date1 {
            CommonFunctions.shared.showToast(self.view, "End time should be greater then start time")
            print("End time should be greater then start time")
        }else if hours == 6 && minutes > 0 {
            CommonFunctions.shared.showToast(self.view, "End time should not be more then 6 hours from start time")
            print("End time should not be more then 6 hours from start time")
        }else if hours > 6 {
            CommonFunctions.shared.showToast(self.view, "End time should not be more then 6 hours from start time")
            print("End time should not be more then 6 hours from start time")
        }else {
            return true
        }
        
        return false
    }
    
    func generateStartEndTimes() {
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        let lv_formatter = DateFormatter()
        lv_formatter.timeZone = TimeZone(abbreviation: "UTC")
        lv_formatter.locale = Locale(identifier: "en_US_POSIX")
        lv_formatter.dateFormat = "EEE MMM dd HH:mm:ss zzzZ yyyy"
        
        let currentDate = Date()
        let startDate = df.string(from: currentDate)
        var endDate = df.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
        
        if Int(selectedEndHour)! >= Int(selectedStartHour)! {
            endDate = startDate
        }
        
        df.dateFormat = "dd-MM-yyyy hh:mm a"
        let date1 = df.date(from: startDate + " " + startTime)!
        let date2 = df.date(from: endDate + " " + endTime)!
        
        startUTCDate = lv_formatter.string(from: date1)
        startUTCDate = startUTCDate.replacingOccurrences(of: "GMT", with: "UTC")
        endUTCDate = lv_formatter.string(from: date2)
        endUTCDate = endUTCDate.replacingOccurrences(of: "GMT", with: "UTC")
    }
    
    func configureLocationServices() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
//    func getAddress(lat : Double , long : Double) {
//        let geoCoder = CLGeocoder()
//        tfSource.text = ""
//        var address = ""
//        let loc: CLLocation = CLLocation(latitude:lat, longitude: long)
//
//        geoCoder.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil){
//                    print("reverse geodcode fail: \(error!.localizedDescription)")}
//                if let pm = placemarks as? [CLPlacemark]{
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//                        let addressString : String = ""
//                        if pm.subLocality != nil {
//                            address = address + pm.subLocality! + ", "}
//                        if pm.thoroughfare != nil {
//                            address = address + pm.thoroughfare! + ", "}
//                        if pm.locality != nil {
//                            address = address + pm.locality! + ", "}
//                        if pm.country != nil {
//                            address = address + pm.country!
//                        }
//                        self.tfSource.text = address
//
//                        print(addressString)
//                    }
//                }
//        })
//    }

    func add_Pin(_ lat : Double , _ lng : Double){
        mapView.clear()
        let position = CLLocationCoordinate2DMake(lat,lng)
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }
    
    func getAddress(_ lat : Double , _ lng : Double){
        
        var addressString = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lng)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if placemarks != nil{
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var data = pm.addressDictionary as! [String:AnyObject]
                    
                    if let street = data["Street"] as? String{
                        addressString = addressString + street + ", "
                    }
                    if let sub_locality = data["SubLocality"] as? String{
                        addressString = addressString + sub_locality + ", "
                    }
                    if let City = data["City"] as? String{
                        addressString = addressString + City + ", "
                    }
                    if let State = data["State"] as? String{
                        addressString = addressString + State + ", "
                    }
                    if let Country = data["Country"] as? String{
                        addressString = addressString + Country + ", "
                    }
                    if let CountryCode = data["CountryCode"] as? String{
                        addressString = addressString + CountryCode + ", "
                    }
                    if let ZIP = data["ZIP"] as? String{
                        addressString = addressString + ZIP + " "
                    }
                    print(addressString)
                    
                    self.tfSource.text = addressString
                }
            }
        })
    }
    
    //MARK:- Web Service Calling
    func callGetWashPriceAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_PRICE
        
        APIManager.shared.requestGetURL(serviceURL, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                self.farePrice = "\(jsonObject["price"] as! Int)"
                self.lblPrice.text = String(format: "%.2f", Double(self.farePrice)!)
                self.setPrice()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callBookCarWashAPI(_ vehicleID: String, _ cardId: String, _ addressLine:String, _ notes: String, _ promo: String, _ bookingDate: String) {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.BOOK_WASH
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "location": addressLine,
            "vehicle_id": vehicleID,
            "date": bookingDate,
            "start_time": startUTCDate,
            "end_time": endUTCDate,
            "fare": farePrice,
            "payment_type": "card",
            "lot_no": "123",
            "card_id": cardId,
            "lat": "\(latitude)",
            "lon": "\(longitude)",
            "notes": notes,
            "promo": promo
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        UserModel.sharedInstance().selectedCardID = nil
                        UserModel.sharedInstance().selectedCardName = nil
                        UserModel.sharedInstance().selectedVehicleID = nil
                        UserModel.sharedInstance().selectedVehicleName = nil
                        UserModel.sharedInstance().selectedPromoCode = nil
                        UserModel.sharedInstance().selectedPromoType = nil
                        UserModel.sharedInstance().synchroniseData()
                        //CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                    }else if status == 402 {
                        self.showAlertView(jsonObject["message"] as? String)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWallet"{
            let vc = segue.destination as! WalletVC
            vc.comeFrom = sender as! String
        }else if segue.identifier == "toVehicle" {
            let vc = segue.destination as! ViewVehicleVC
            vc.comeFrom = sender as! String
        }
    }
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
        add_Pin(center.latitude, center.longitude)
        self.latitude = Double(center.latitude)
        self.longitude = Double(center.longitude)
        self.getAddress( Double(center.latitude) , Double(center.longitude) )
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
//Delegate Method for auto complete view controller.
extension HomeVC: GMSAutocompleteViewControllerDelegate {
    
    //Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                     longitude: place.coordinate.longitude,
                                                     zoom: Float(15))
               
       mapView.camera = camera
       add_Pin(place.coordinate.latitude, place.coordinate.longitude)
       self.latitude = Double(place.coordinate.latitude)
       self.longitude = Double(place.coordinate.longitude)

        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
                self.showAlertView("Unable to Find Address for Location")
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.tfSource.text = placemark.compactAddress
                } else {
                    self.showAlertView("No Matching Addresses Found")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    //User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
