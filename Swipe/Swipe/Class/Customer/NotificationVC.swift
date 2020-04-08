//
//  NotificationVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class NotificationCell : UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
}

class NotificationVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tblNotifications: CustomUITableView!
    
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var vwDelete: CustomUIView!
    //MARK:- Global Variables
    var arrNotificationList = [[String:AnyObject]]()
    
    var isNotification = false
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
        callGetNotificationListAPI()
    }
    
    //MARK:- Button Actions
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    
    @IBAction func btnDelete_Action(_ sender: UIButton) {
        self.blurView.isHidden = false
        self.vwDelete.isHidden = false
    }
    
    @IBAction func btnDeletePopup_Action(_ sender: Any) {
        callDeleteNotificationsAPI()
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.blurView.isHidden = true
        self.vwDelete.isHidden = true
    }
    
    //MARK:- Webservices
    func callGetNotificationListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.USER_NOTIFICATION
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "user_type": "customer"]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                self.blurView.isHidden = true
                self.vwDelete.isHidden = true
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let notifications = jsonObject["notifications"] as? [[String:AnyObject]], notifications.count > 0 {
                        self.btnDelete.isHidden = false
                        self.arrNotificationList = notifications
                        self.tblNotifications.reloadData()
                        
                    }else {
                        self.btnDelete.isHidden = true
                        self.arrNotificationList.removeAll()
                        self.tblNotifications.reloadData()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callDeleteNotificationsAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.DELETE_NOTIFICATION
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "user_type": "customer"]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    self.callGetNotificationListAPI()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let vc = segue.destination as! NotificationDetailVC
            vc.data = sender as! [String:AnyObject]
        }
    }
}

extension NotificationVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrNotificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath ) as! NotificationCell
        
        cell.lblTitle.text = arrNotificationList[indexPath.row]["notification_title"] as? String
        cell.lblMessage.text = arrNotificationList[indexPath.row]["notification_desc"] as? String
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = arrNotificationList[indexPath.row]
        
        if data["page"] as! String == "complete_booking"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }else if data["page"] as! String == "start_wash"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }else if data["page"] as! String == "cancle_wash"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }else if data["page"] as! String == "wash_accept"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }else if data["page"] as! String == "reedeem_stamp"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }
        
        
        //self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        
        
//        let dictData = arrNotificationList[indexPath.row]
//        if dictData["page"] as! String == "complete_booking" {
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
//            destVC.isScheduled = false
//            self.navigationController?.pushViewController(destVC, animated: true)
//        }else if dictData["page"] as! String == "wash_accept" {
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
//            destVC.isScheduled = true
//            self.navigationController?.pushViewController(destVC, animated: true)
//        }else if dictData["page"] as! String == "start_wash" {
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
//            destVC.isScheduled = true
//            self.navigationController?.pushViewController(destVC, animated: true)
//        }else if dictData["page"] as! String == "reedeem_stamp" {
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardVC") as! RewardVC
//            destVC.isFromNotification = true
//            self.navigationController?.pushViewController(destVC, animated: true)
//        }
    }
}
