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
        btnScheduled.setTitleColor(AppColors.cyan, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblScheduledBtm.isHidden = false
        lblHistoryBtm.isHidden = true
        callGetScheduleListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
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
            vc.bookingStatus = sender as! String
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "toDetail", sender: "upcoming")
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "toDetail", sender: "accept")
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "toHistoryDetail", sender: "accept")
        }
        
    }
}
