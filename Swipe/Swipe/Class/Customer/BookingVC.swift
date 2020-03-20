//
//  BookingVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class BookingCell : UITableViewCell{
    @IBOutlet weak var lblCarDetail: UILabel!
    @IBOutlet weak var lblStartEndTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ivCardType: CustomImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCarType: CustomLabel!
    @IBOutlet weak var lblStatus: UILabel!
}

class BookingVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var btnScheduled: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblScheduledBtm: UILabel!
    @IBOutlet weak var lblHistoryBtm: UILabel!

    @IBOutlet weak var tblBooking: UITableView!
    
    //MARK:- Global Variables
    var arrScheduledDictData = [[String:AnyObject]]()
    var arrHistoryDictData = [[String:AnyObject]]()
    var isScheduled = true
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
        isScheduled = true
        btnScheduled.setTitleColor(AppColors.cyan, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblScheduledBtm.isHidden = false
        lblHistoryBtm.isHidden = true
        callGetScheduleListAPI()
    }
    
    //MARK:- Button Actions
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnScheduled_Action(_ sender: Any) {
        btnScheduled.setTitleColor(AppColors.cyan, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblScheduledBtm.isHidden = false
        lblHistoryBtm.isHidden = true
        isScheduled = true
        callGetScheduleListAPI()
    }
    
    @IBAction func btnHistory_Action(_ sender: Any) {
        btnScheduled.setTitleColor(UIColor.lightGray, for: .normal)
        btnHistory.setTitleColor(AppColors.cyan, for: .normal)
        lblScheduledBtm.isHidden = true
        lblHistoryBtm.isHidden = false
        isScheduled = false
        callGetHistoryListAPI()
    }
    
    //MARK:- Webservices
    func callGetScheduleListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.SCHEDULE_BOOKING
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["my_booking"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrScheduledDictData = data
                    self.tblBooking.reloadData()
                }else{
                    self.arrScheduledDictData.removeAll()
                    self.tblBooking.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetHistoryListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.HISTORY_BOOKING
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["my_booking"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrHistoryDictData = data
                    self.tblBooking.reloadData()
                }else{
                    self.arrHistoryDictData.removeAll()
                    self.tblBooking.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let vc = segue.destination as! BookingDetailVC
//            vc.bookingStatus = sender as! String
            
            let selectedRow = sender as! Int
            let dictData = arrScheduledDictData[selectedRow]
            
            if let id = dictData["id"] as? Int {
                vc.washID = "\(id)"
            }
            
            if let status = dictData["status"] as? String {
                vc.bookingStatus = status
            }
            
            if let longitude = dictData["lon"] as? String {
                vc.longitude = longitude
            }
            
            if let latitude = dictData["lat"] as? String {
                vc.latitude = latitude
            }
            
            if let booking_id = dictData["id"] as? Int {
                vc.booking_Id = "\(booking_id)"
            }
            
            if let bookingStartDate = dictData["start_time"] as? String {
                vc.bookingStartDate = bookingStartDate
            }
            
            if let bookingEndDate = dictData["end_time"] as? String {
                vc.bookingEndDate = bookingEndDate
            }
            
            if let brandName = dictData["brand_name"] as? String, let modelName = dictData["model_name"] as? String, let plateNo = dictData["vehicle_no"] as? String {
                vc.vehicleName = "\(brandName) \(modelName) (\(plateNo))"
            }
            
            if let type = dictData["type"] as? String {
                vc.vehicleType = type
            }
            
            if let address = dictData["location"] as? String {
                vc.address = address
            }
            
            if let isPromo = dictData["isPromo"] as? Int, isPromo == 1 {
                vc.isPromo = true
                if let promo = dictData["booking_promp"] as? String {
                    vc.promocode = promo
                }
            }else {
                vc.isPromo = false
            }
             
            if let farePrice = dictData["fare"] as? String {
                vc.farePrice = farePrice
            }
            
            if let washerData = dictData["washer_profile"] as? [String:AnyObject] {
                if let washers = dictData["washers"] as? [String:AnyObject] {
                    if let washerName = washers["name"] as? String {
                        vc.washerName = washerName
                    }
                }
                if let profilePic = washerData["profile_pic"] as? String {
                    vc.washerProfile = profilePic
                }
                
                if let upVoteCnt = washerData["upvote_count"] as? Int {
                    vc.washerUpVoteCnt = upVoteCnt
                }
                
                if let downVoteCnt = washerData["downvote_count"] as? Int {
                    vc.washerDownVoteCnt = downVoteCnt
                }
                
                if let washer_id = washerData["id"] as? Int {
                    vc.washID = "\(washer_id)"
                }
                
                
            }
            
        }else if segue.identifier == "toHistoryDetail" {
            let vc = segue.destination as! BookingHistoryDetailVC
            let selectedRow = sender as! Int
            let dictData = arrHistoryDictData[selectedRow]
            
            if let id = dictData["id"] as? Int {
                vc.washID = "\(id)"
            }
            
            if let is_rated = dictData["is_rated"] as? Int, is_rated == 1 {
                vc.isRated = true
            }else {
                vc.isRated = false
            }
            
            if let jobCode = dictData["job_code"] as? String {
                vc.bookingID = jobCode
            }
            
            if let status = dictData["status"] as? String, status == "Completed" {
                if let bookingDate = dictData["wash_completed_date"] as? String {
                    vc.bookingDate = bookingDate
                }
            }else {
                if let bookingDate = dictData["end_time"] as? String {
                    vc.bookingDate = bookingDate
                }
            }
            
            
            
            if let brandName = dictData["brand_name"] as? String, let modelName = dictData["model_name"] as? String, let plateNo = dictData["vehicle_no"] as? String {
                vc.vehicleName = "\(brandName) \(modelName) (\(plateNo))"
            }
            
            if let type = dictData["type"] as? String {
                vc.vehicleType = type
            }
            
            if let address = dictData["location"] as? String {
                vc.address = address
            }
            
            if let isPromo = dictData["isPromo"] as? Int, isPromo == 1 {
                vc.isPromo = true
                
                if let promo = dictData["booking_promp"] as? String {
                    vc.promocode = promo
                }
            }else {
                vc.isPromo = false
            }
             
            if let farePrice = dictData["fare"] as? String {
                vc.farePrice = farePrice
            }
            
            if let washerData = dictData["washer_profile"] as? [String:AnyObject] {
                if let washers = dictData["washers"] as? [String:AnyObject] {
                    if let washerName = washers["name"] as? String {
                        vc.washerName = washerName
                    }
                    
                    if let washerID = washers["id"] as? Int {
                        vc.washerID = "\(washerID)"
                    }
                }
                if let profilePic = washerData["profile_pic"] as? String {
                    vc.washerProfile = profilePic
                }
            }
            
            if let washCompletedDate = dictData["wash_completed_date"] as? String {
                vc.completeDate = washCompletedDate
            }
            
            if let bookingCompletedImg1 = dictData["booking_complete_image1"] as? String {
                vc.vehicle1 = bookingCompletedImg1
            }
            
            if let bookingCompletedImg2 = dictData["booking_complete_image2"] as? String {
                vc.vehicle2 = bookingCompletedImg2
            }
            
        }
    }
}

extension BookingVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isScheduled {
            return arrScheduledDictData.count
        }else {
            return arrHistoryDictData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath ) as! BookingCell
    
        if isScheduled {
            let dictData = arrScheduledDictData[indexPath.row]
            cell.lblLocation.text = dictData["location"] as? String
            
            let brand = dictData["brand_name"] as! String
            let model = dictData["model_name"] as! String
            let plate = dictData["vehicle_no"] as! String
            cell.lblCarDetail.text = "\(brand) \(model) (\(plate))"
            
            cell.lblCarType.text = dictData["type"] as? String
            cell.lblStatus.text = dictData["status"] as? String
            
            let price = dictData["fare"] as! String
            cell.lblPrice.text = String(format: "SGD %.2f", Double(price)!)
            
            if let card_no = dictData["card_no"] as? String {
                cell.lblCardNo.text = String(card_no.suffix(4))
                
                if card_no.isVisaCard {
                    cell.ivCardType.image = UIImage(named: "color_visa")
                }else if card_no.isMasterCard {
                    cell.ivCardType.image = UIImage(named: "color_master")
                }else if card_no.isExpressCard {
                    cell.ivCardType.image = UIImage(named: "color_american")
                }else if card_no.isDinerClubCard {
                    cell.ivCardType.image = UIImage(named: "dinersclub")
                }else if card_no.isDiscoverCard {
                    cell.ivCardType.image = UIImage(named: "discover")
                }else if card_no.isJCBCard {
                    cell.ivCardType.image = UIImage(named: "jcb")
                }else {
                    cell.ivCardType.image = UIImage(named: "default_card_new")
                }
            }
            
            if let startTime = dictData["start_time"] as? String, let endTime = dictData["end_time"] as? String {
                let df = DateFormatter()
                df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                df.locale = Locale(identifier: "en_US_POSIX")
                df.timeZone = TimeZone(abbreviation: "UTC")
                let parsedStartDate = df.date(from: startTime)
                let parsedEndDate = df.date(from: endTime)
                
                df.dateFormat = "hh:mm a"
                df.timeZone = TimeZone.current
                let convertedStartTime = df.string(from: parsedStartDate!)
                let convertedEndTime = df.string(from: parsedEndDate!)
                
                let sameDay = Calendar.current.isDate(parsedStartDate!, inSameDayAs: parsedEndDate!)
                if sameDay {
                    cell.lblStartEndTime.text = "Today, \(convertedStartTime) - \nToday, \(convertedEndTime)"
                }else {
                    cell.lblStartEndTime.text = "Today, \(convertedStartTime) - \nTomorrow, \(convertedEndTime)"
                }
            }
        }else {
            let dictData = arrHistoryDictData[indexPath.row]
            cell.lblLocation.text = dictData["location"] as? String
            
            let brand = dictData["brand_name"] as! String
            let model = dictData["model_name"] as! String
            let plate = dictData["vehicle_no"] as! String
            cell.lblCarDetail.text = "\(brand) \(model) (\(plate))"
            
            cell.lblCarType.text = dictData["type"] as? String
            cell.lblStatus.text = dictData["status"] as? String
            
            let price = dictData["fare"] as! String
            cell.lblPrice.text = String(format: "SGD %.2f", Double(price)!)
            
            if let card_no = dictData["card_no"] as? String {
                cell.lblCardNo.text = String(card_no.suffix(4))
                
                if card_no.isVisaCard {
                    cell.ivCardType.image = UIImage(named: "color_visa")
                }else if card_no.isMasterCard {
                    cell.ivCardType.image = UIImage(named: "color_master")
                }else if card_no.isExpressCard {
                    cell.ivCardType.image = UIImage(named: "color_american")
                }else if card_no.isDinerClubCard {
                    cell.ivCardType.image = UIImage(named: "dinersclub")
                }else if card_no.isDiscoverCard {
                    cell.ivCardType.image = UIImage(named: "discover")
                }else if card_no.isJCBCard {
                    cell.ivCardType.image = UIImage(named: "jcb")
                }else {
                    cell.ivCardType.image = UIImage(named: "default_card_new")
                }
            }
            
            if dictData["status"] as! String == "Completed" {
                if let startTime = dictData["wash_completed_date"] as? String {
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    df.locale = Locale(identifier: "en_US_POSIX")
                    df.timeZone = TimeZone(abbreviation: "UTC")
                    let parsedStartDate = df.date(from: startTime)
                    
                    df.dateFormat = "dd MMM yyyy, hh:mm a"
                    df.timeZone = TimeZone.current
                    
                    cell.lblStartEndTime.text = df.string(from: parsedStartDate!)
                }else {
                    cell.lblStartEndTime.text = ""
                }
            }else {
                if let startTime = dictData["start_time"] as? String, let endTime = dictData["end_time"] as? String {
                    let df = DateFormatter()
                    df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                    df.locale = Locale(identifier: "en_US_POSIX")
                    df.timeZone = TimeZone(abbreviation: "UTC")
                    let parsedStartDate = df.date(from: startTime)
                    let parsedEndDate = df.date(from: endTime)
                    
                    df.dateFormat = "dd MMM yyyy, hh:mm a"
                    df.timeZone = TimeZone.current
                    let convertedStartTime = df.string(from: parsedStartDate!)
                    let convertedEndTime = df.string(from: parsedEndDate!)
                    
                    if dictData["status"] as! String == "Expired" {
                        cell.lblStartEndTime.text = "\(convertedStartTime)"
                    }else {
                        cell.lblStartEndTime.text = "\(convertedEndTime)"
                    }
                }else {
                    cell.lblStartEndTime.text = ""
                }
            }
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isScheduled {
            self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
        }else {
            let dictData = arrHistoryDictData[indexPath.row]
            let type = dictData["status"] as? String
            if type == "Completed" {
                self.performSegue(withIdentifier: "toHistoryDetail", sender: indexPath.row)
            }
        }
        
//        if indexPath.row == 0{
//            self.performSegue(withIdentifier: "toDetail", sender: "upcoming")
//        }else if indexPath.row == 1{
//            self.performSegue(withIdentifier: "toDetail", sender: "accept")
//        }else if indexPath.row == 2{
//
//        }
        
    }
}
