//
//  Booking_washer_VC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ConfirmedBookingCell : UITableViewCell{
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblBookingStatus: UILabel!
    @IBOutlet weak var lblVehicleType: CustomLabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
}

class AvailableBookingCell : UITableViewCell{
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblVehicleType: CustomLabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class Booking_washer_VC: Main {

    //MARK:- Outlets
    @IBOutlet weak var btnConfirmed: UIButton!
    @IBOutlet weak var btnAvailable: UIButton!
    
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var consWidthScreen: NSLayoutConstraint!
    //@IBOutlet weak var consHeightScreen: NSLayoutConstraint!
    
    @IBOutlet weak var tblConfirmed: UITableView!
    @IBOutlet weak var tblAvailable: UITableView!
    
    //MARK:- Global Variables
    var isConfirmed = false
    var arrAvailableList = [[String:AnyObject]]()
    var arrConfirmedList = [[String:AnyObject]]()

    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isConfirmed = true
        consWidthScreen.constant = self.view.frame.size.width
        //consHeightScreen.constant = self.view.frame.size.height - 140
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        btnConfirmed.setTitleColor(AppColors.cyan, for: .normal)
        btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
        lblConfirm.isHidden = false
        lblAvailable.isHidden = true
        callGetConfirmedListAPI()
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
    
    //MARK:- Button Actions
    @IBAction func btnSideMenu_Action(_ sender: Any) {
        toggleSideMenuView()
    }
    
    @IBAction func btnComfirmed_Action(_ sender: Any) {
        isConfirmed = true
        callGetConfirmedListAPI()
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    @IBAction func btnAvailable_Action(_ sender: Any) {
        isConfirmed = false
        callGetAvailableListAPI()
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width, y:0), animated: true)
    }
    
    //MARK:- Webservices
    func callGetAvailableListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.AVAILBLE_WASHES
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)&lat=\(LocationManager.sharedInstance.latitude)&lon=\(LocationManager.sharedInstance.longitude)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let data = jsonObject["request_wash"] as? [[String:AnyObject]], data.count > 0{
                        print(data)
                        self.arrAvailableList = data
                        self.tblAvailable.reloadData()
                    }else{
                        self.arrAvailableList.removeAll()
                        self.tblAvailable.reloadData()
                    }
                }else{
                    self.arrAvailableList.removeAll()
                    self.tblAvailable.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetConfirmedListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.CONFIRMED_WASHES
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)&lat=\(LocationManager.sharedInstance.latitude)&lon=\(LocationManager.sharedInstance.longitude)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let data = jsonObject["accepted_wash"] as? [[String:AnyObject]], data.count > 0{
                        print(data)
                        self.arrConfirmedList = data
                        self.tblConfirmed.reloadData()
                    }else{
                        self.arrConfirmedList.removeAll()
                        self.tblConfirmed.reloadData()
                    }
                }else {
                    self.arrConfirmedList.removeAll()
                    self.tblConfirmed.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirm" {
            let dictData = arrConfirmedList[sender as! Int]
            
            let destVC = segue.destination as! ConfWasherBookingVC
            destVC.locationName = dictData["location"] as! String
            destVC.username = dictData["user_name"] as! String
            destVC.notes = dictData["notes"] as! String
            destVC.vehicleName = "\(dictData["brand_name"] as! String) \(dictData["model_name"] as! String)"
            destVC.plateNo = dictData["vehicle_no"] as! String
            destVC.vehicleType = dictData["type"] as! String
            destVC.price = dictData["fare"] as! String
            destVC.user_id = dictData["user_id"] as! String
            if let status = dictData["status"] as? String, status != "" {
                destVC.status = status
            }
            
            if let latitude = dictData["lat"] as? String, latitude != "" {
                destVC.latitude = Double(latitude)!
            }
            
            if let longitude = dictData["lon"] as? String, longitude != "" {
                destVC.longitude = Double(longitude)!
            }
            
            if let washID = dictData["id"] as? Int {
                destVC.washID = "\(washID)"
            }
            
            if let unread_message_washer = dictData["unread_message_washer"] as? [[String:AnyObject]] {
                destVC.unreadCnt = unread_message_washer.count
            }
            
        }else if segue.identifier == "toAvailable" {
            let dictData = arrAvailableList[sender as! Int]
            
            let destVC = segue.destination as! AvailWasherBookingVC
            destVC.locationName = dictData["location"] as! String
            destVC.username = dictData["user_name"] as! String
            destVC.vehicleType = dictData["type"] as! String
            destVC.price = dictData["fare"] as! String
            
            if let latitude = dictData["lat"] as? String, latitude != "" {
                destVC.latitude = Double(latitude)!
            }
            
            if let longitude = dictData["lon"] as? String, longitude != "" {
                destVC.longitude = Double(longitude)!
            }
            
            if let distance = dictData["distance"] as? Double {
                destVC.distance = distance
            }
            
            if let washID = dictData["id"] as? Int {
                destVC.washID = "\(washID)"
            }
        }
    }
}

extension Booking_washer_VC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page_Number = round(scrView.contentOffset.x / scrView.frame.size.width)
        print(page_Number)
        if page_Number == 0.0 {
            btnConfirmed.setTitleColor(AppColors.cyan, for: .normal)
            btnAvailable.setTitleColor(UIColor.white, for: .normal)
            lblConfirm.isHidden = false
            lblAvailable.isHidden = true
        }else if page_Number == 1.0 {
            btnConfirmed.setTitleColor(UIColor.white, for: .normal)
            btnAvailable.setTitleColor(AppColors.cyan, for: .normal)
            lblAvailable.isHidden = false
            lblConfirm.isHidden = true
            
        }
    }
}

extension Booking_washer_VC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblConfirmed{
            return arrConfirmedList.count
        }else{
            return arrAvailableList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblConfirmed {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmedBookingCell", for: indexPath) as! ConfirmedBookingCell
            
            let dictData = arrConfirmedList[indexPath.row]
            if let username = dictData["user_name"] as? String {
                cell.lblUsername.text = username
            }
            
            if let status = dictData["status"] as? String {
                cell.lblBookingStatus.text = status
                
                if status == "Accepted" {
                    cell.lblBookingStatus.textColor = UIColor(red: 51/255, green: 153/255, blue: 51/255, alpha: 1.0)
                }else {
                    cell.lblBookingStatus.textColor = UIColor(red: 211/255, green: 10/255, blue: 0/255, alpha: 1.0)
                }
            }
            
            if let type = dictData["type"] as? String {
                cell.lblVehicleType.text = type
            }
            
            if let location = dictData["location"] as? String {
                cell.lblLocation.text = location
            }
            
            if let distance = dictData["distance"] as? Double {
                cell.lblDistance.text = String (format: "%.2fKm away from your location", distance)
            }
            
            if let fare = dictData["fare"] as? String, fare != "" {
                cell.lblPrice.text = String (format: "SGD %.2f", Double(fare)!)
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableBookingCell", for: indexPath) as! AvailableBookingCell
            
            let dictData = arrAvailableList[indexPath.row]
            if let username = dictData["user_name"] as? String {
                cell.lblUsername.text = username
            }
            
            if let type = dictData["type"] as? String {
                cell.lblVehicleType.text = type
            }
            
            if let location = dictData["location"] as? String {
                cell.lblLocation.text = location
            }
            
            if let distance = dictData["distance"] as? Double {
                cell.lblDistance.text = String (format: "%.2fKm away from your location", distance)
            }
            
            if let fare = dictData["fare"] as? String, fare != "" {
                cell.lblPrice.text = String (format: "SGD %.2f", Double(fare)!)
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isConfirmed{
            self.performSegue(withIdentifier: "toConfirm", sender: indexPath.row)
        }else{
            self.performSegue(withIdentifier: "toAvailable", sender: indexPath.row)
        }
    }
}
