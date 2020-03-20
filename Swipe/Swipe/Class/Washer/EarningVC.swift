//
//  EarningVC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class CalenderCell : UICollectionViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}

class EarningCell : UITableViewCell{
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblVehicleType: CustomLabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class EarningVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var btnDaily: CustomButton!
    @IBOutlet weak var btnWeekly: CustomButton!
    @IBOutlet weak var cvDateList: UICollectionView!
    @IBOutlet weak var tblWashes: UITableView!
    
    @IBOutlet weak var lblTotalPrices: UILabel!
    @IBOutlet weak var lblTotalWashes: UILabel!
    
    
    //MARK:- Global Variables
    var isDaily = true
    var arrDailyDateList = [[String:AnyObject]]()
    var arrWeeklyDateList = [[String:AnyObject]]()
    
    var arrDailyWashData = [[String:AnyObject]]()
    var arrWeeklyWashData = [[String:AnyObject]]()
    
    var selectedIndex = 0
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        callDailyDateList()
        tblWashes.tableFooterView = UIView()
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }

    @IBAction func btnDaily_Action(_ sender: Any) {
        btnDaily.backgroundColor = AppColors.cyan
        btnWeekly.backgroundColor = UIColor.clear
        isDaily = true
        callDailyDateList()
    }
    
    @IBAction func btnWeekly_Action(_ sender: Any) {
        btnWeekly.backgroundColor = AppColors.cyan
        btnDaily.backgroundColor = UIColor.clear
        isDaily = false
        callWeeklyDateList()
    }
    
    //MARK:- Webservices
    func callDailyDateList() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_DATE_LIST
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["wash_dates"] as? [[String:AnyObject]], data.count > 0{
                    self.arrDailyDateList = data
                    self.cvDateList.reloadData()
                    
                    self.selectedIndex = 0
                    self.callDailyEarningList(self.arrDailyDateList[0]["date"] as! String)
                }else{
                    self.arrDailyDateList.removeAll()
                    self.cvDateList.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callWeeklyDateList() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_WEEK_LIST
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["wash_week"] as? [[String:AnyObject]], data.count > 0 {
                    self.arrWeeklyDateList = data
                    self.cvDateList.reloadData()
                    
                    self.selectedIndex = 0
                    self.callWeeklyEarningList(self.arrWeeklyDateList[0]["week"] as! String, self.arrWeeklyDateList[0]["year"] as! String)
                }else {
                    self.arrWeeklyDateList.removeAll()
                    self.cvDateList.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callDailyEarningList(_ strDate : String) {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_LIST_BY_DATE
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "date": strDate]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let washDates = jsonObject["wash_dates"] as? [[String:AnyObject]], washDates.count > 0 {
                        self.arrDailyWashData = washDates
                        self.tblWashes.reloadData()
                    }else {
                        self.arrDailyWashData.removeAll()
                        self.tblWashes.reloadData()
                    }
                    if let total_prices = jsonObject["earnings"] as? Int {
                        self.lblTotalPrices.text = String(format: "%.2f", Double(total_prices))
                    }
                    
                    if let total_washes = jsonObject["totalWashes"] as? Int {
                        self.lblTotalWashes.text = "\(total_washes)"
                    }
                    
                }else {
                    self.arrDailyWashData.removeAll()
                    self.tblWashes.reloadData()
                }
            }else {
                self.arrDailyWashData.removeAll()
                self.tblWashes.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callWeeklyEarningList(_ week : String, _ year: String) {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.WASH_LIST_BY_WEEK
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "week": week, "year": year]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let washDates = jsonObject["wash_dates"] as? [[String:AnyObject]], washDates.count > 0 {
                        self.arrWeeklyWashData = washDates
                        self.tblWashes.reloadData()
                    }else {
                        self.arrWeeklyWashData.removeAll()
                        self.tblWashes.reloadData()
                    }
                    if let total_prices = jsonObject["earnings"] as? Int {
                        self.lblTotalPrices.text = String(format: "%.2f", Double(total_prices))
                    }
                    
                    if let total_washes = jsonObject["totalWashes"] as? Int {
                        self.lblTotalWashes.text = "\(total_washes)"
                    }
                    
                }else {
                    self.arrWeeklyWashData.removeAll()
                    self.tblWashes.reloadData()
                }
            }else {
                self.arrWeeklyWashData.removeAll()
                self.tblWashes.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! SwipeBoxDetailVC
            destVC.washID = sender as! Int
        }
    }
}

extension EarningVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDaily {
            return arrDailyWashData.count
        }else {
            return arrWeeklyWashData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath) as! EarningCell
        
        if isDaily {
            let dictData = arrDailyWashData[indexPath.row]
            
            if let startTime = dictData["start_time"] as? String {
                let df = DateFormatter()
                df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                df.locale = Locale(identifier: "en_US_POSIX")
                df.timeZone = TimeZone(abbreviation: "UTC")
                let parsedStartDate = df.date(from: startTime)
                
                df.dateFormat = "hh:mm a"
                df.timeZone = TimeZone.current
                let convertedStartTime = df.string(from: parsedStartDate!)
                
                cell.lblTime.text = convertedStartTime
            }
            
            if let location = dictData["location"] as? String {
                cell.lblAddress.text = location
            }
            
            if let vehicleType = dictData["type"] as? String {
                cell.lblVehicleType.text = vehicleType
            }
            
            if let price = dictData["fare"] as? String {
                cell.lblPrice.text = String(format: "SGD %.2f", Double(price)!)
            }
        }else {
            let dictData = arrWeeklyWashData[indexPath.row]
            
            if let startTime = dictData["start_time"] as? String {
                let df = DateFormatter()
                df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                df.locale = Locale(identifier: "en_US_POSIX")
                df.timeZone = TimeZone(abbreviation: "UTC")
                let parsedStartDate = df.date(from: startTime)
                
                df.dateFormat = "hh:mm a"
                df.timeZone = TimeZone.current
                let convertedStartTime = df.string(from: parsedStartDate!)
                
                cell.lblTime.text = convertedStartTime
            }
            
            if let location = dictData["location"] as? String {
                cell.lblAddress.text = location
            }
            
            if let vehicleType = dictData["type"] as? String {
                cell.lblVehicleType.text = vehicleType
            }
            
            if let price = dictData["fare"] as? String {
                cell.lblPrice.text = String(format: "SGD %.2f", Double(price)!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDaily {
            self.performSegue(withIdentifier: "toDetail", sender: arrDailyWashData[indexPath.row]["id"] as! Int)
        }else {
            self.performSegue(withIdentifier: "toDetail", sender: arrWeeklyWashData[indexPath.row]["id"] as! Int)
        }
        
    }
}

extension EarningVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDaily {
            return arrDailyDateList.count
        }else {
            return arrWeeklyDateList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalenderCell
        
        if selectedIndex == indexPath.row {
            cell.contentView.backgroundColor = UIColor(hexString: "#4EB8F5")
        }else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        if isDaily {
            let dictData = arrDailyDateList[indexPath.row]
            if let date = dictData["date"] as? String {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let parsedDt = df.date(from: date)!
                
                df.dateFormat = "E"
                cell.lblName.text = df.string(from: parsedDt)
                
                df.dateFormat = "dd"
                cell.lblDate.text = df.string(from: parsedDt)
            }
        }else {
            let dictData = arrWeeklyDateList[indexPath.row]
            if let weekStr = dictData["week"] as? String, let yearStr = dictData["year"] as? String {
                
                let year = Int(yearStr)!
                let weekOfYear = Int(weekStr)!
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                
                let components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
                var startDate = Calendar.current.date(from: components)
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate!)
                
                df.dateFormat = "MMM"
                
                let startMonth = df.string(from: startDate!)
                let endMonth = df.string(from: endDate!)
                
                if startMonth == endMonth {
                    cell.lblName.text = "\(startMonth)"
                }else {
                    cell.lblName.text = "\(startMonth)/\(endMonth)"
                }
                
                df.dateFormat = "dd"
                cell.lblDate.text = "\(df.string(from: startDate!))-\(df.string(from: endDate!))"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 6, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        cvDateList.reloadData()
        
        if isDaily {
            callDailyEarningList(arrDailyDateList[indexPath.row]["date"] as! String)
        }else {
            callWeeklyEarningList(arrWeeklyDateList[indexPath.row]["week"] as! String, arrWeeklyDateList[indexPath.row]["year"] as! String)
        }
        
    }
}

