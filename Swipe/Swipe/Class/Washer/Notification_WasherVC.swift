//
//  Notification_WasherVC.swift
//  Swipe
//
//  Created by My Mac on 01/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class NotificationWasherCell : UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
}

class Notification_WasherVC: Main {

    //MARK:- Global Variables
    var arrNotificationList = [[String:AnyObject]]()
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tblNotifications: CustomUITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
        callGetNotificationListAPI()
    }
    
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }
    
    @IBAction func btnDelete_Action(_ sender: UIButton) {
        callDeleteNotificationsAPI()
    }
    
    //MARK:- Webservices
    func callGetNotificationListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.USER_NOTIFICATION
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "user_type": "washer"]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let notifications = jsonObject["notifications"] as? [[String:AnyObject]], notifications.count > 0 {
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
        let parameter : [String:String] = ["token": UserModel.sharedInstance().authToken!, "user_type": "washer"]
        
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
            let vc = segue.destination as! WasherNotificationDetailVC
            vc.data = sender as! [String:AnyObject]
        }
    }
    
}
extension Notification_WasherVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationWasherCell", for: indexPath ) as! NotificationWasherCell
        
        cell.lblTitle.text = arrNotificationList[indexPath.row]["notification_title"] as? String
        cell.lblMessage.text = arrNotificationList[indexPath.row]["notification_desc"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let data = arrNotificationList[indexPath.row]
        
        if data["page"] as! String == "cancle_booking"{
            self.performSegue(withIdentifier: "toDetail", sender: arrNotificationList[indexPath.row])
        }
        
    }
}
