//
//  SwipeBoxVC.swift
//  Swipe
//
//  Created by My Mac on 01/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RedeemCell : UITableViewCell{
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
}

class SwipeBoxVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var lblTap: CustomLabel!
    @IBOutlet weak var ivBlurView: UIImageView!
    @IBOutlet weak var vwInfo: CustomUIView!
    @IBOutlet weak var lblWashCnt: UILabel!
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var vw6: UIView!
    
    @IBOutlet weak var vwRedeem: CustomUIView!
    @IBOutlet weak var btnRedeem: CustomButton!
    
    @IBOutlet weak var tblView: CustomUITableView!
    
    //MARK:- Global Variables
    var arrRedemptionHistory = [[String:AnyObject]]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ivBlurView.isHidden = true
        self.vwInfo.isHidden = true
        self.lblTap.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        ivBlurView.addGestureRecognizer(tap)
        ivBlurView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callWasherRewardData()
    }
    
    //MARK:- Selector Methods
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.ivBlurView.isHidden = true
        self.vwInfo.isHidden = true
        self.lblTap.isHidden = true
    }
    
    //MARK:- Button Actions
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }
    
    @IBAction func btnQuestion_Action(_ sender: Any) {
        self.ivBlurView.isHidden = false
        self.vwInfo.isHidden = false
        self.lblTap.isHidden = false
    }
    @IBAction func btnRedeem_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toRedem", sender: nil)
    }
    
    //MARK:- Webservices
    func callWasherRewardData() {
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
                        self.lblWashCnt.text = "\(completedCount) / 6 Washes"
                        
                        if completedCount == 1 {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }else if completedCount == 2 {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw2.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }else if completedCount == 3 {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw2.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw3.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }else if completedCount == 4 {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw2.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw3.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw4.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }else if completedCount == 5 {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw2.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw3.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw4.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw5.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }else  {
                            self.vw1.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw2.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw3.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw4.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw5.backgroundColor = UIColor(hexString: "#4EB8F5")
                            self.vw6.backgroundColor = UIColor(hexString: "#4EB8F5")
                            
                            self.btnRedeem.isUserInteractionEnabled = true
                            self.vwRedeem.backgroundColor = UIColor(hexString: "#4EB8F5")
                        }
                        
                    }
                    
                    if let arrRedemption = jsonObject["redemption_history"] as? [[String:AnyObject]] {
                        self.arrRedemptionHistory = arrRedemption
                        self.tblView.reloadData()
                    }else {
                        self.arrRedemptionHistory.removeAll()
                        self.tblView.reloadData()
                    }
                }else {
                    self.arrRedemptionHistory.removeAll()
                    self.tblView.reloadData()
                }
            }else {
                self.arrRedemptionHistory.removeAll()
                self.tblView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
}
extension SwipeBoxVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrRedemptionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemCell", for: indexPath ) as! RedeemCell
        
        let dictData = arrRedemptionHistory[indexPath.row]
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parsedDt = df.date(from: dictData["date"] as! String)!
        
        df.dateFormat = "dd MMM yyyy, hh.mm a"
        cell.lblDate.text = df.string(from: parsedDt)
        
        cell.lblCode.text = dictData["code"] as? String
        cell.lblDesc.text = dictData["name"] as? String
        cell.lblStatus.text = dictData["status"] as? String
        
        return cell
    }
}
