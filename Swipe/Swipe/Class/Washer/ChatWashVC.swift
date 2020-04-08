//
//  ChatVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RightWashCell : UITableViewCell{
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var ivTick: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
}

class LeftWashCell : UITableViewCell{
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

class ChatWashVC : Main {
    
    @IBOutlet weak var cnsBottomTV: NSLayoutConstraint!
    @IBOutlet weak var tfMessage: CustomTextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblChat: UITableView!
    
    var booking_id = ""
    var cust_id = ""
    var custName = ""
    var timer = Timer()
    var arrDictChat = [[String:AnyObject]]()
    var isNotification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callGetMessageAPI()
        lblName.text = custName
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatWashVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ChatWashVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden  = true
        setStatusBarColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil{
            if timer.isValid{
                timer.invalidate()
            }
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            DispatchQueue.main.async {
                if self.arrDictChat.count > 0 {
                    self.tblChat.scrollToRow(at: IndexPath(row: self.arrDictChat.count - 1, section: 0), at: .bottom, animated: true)
                }
                self.cnsBottomTV.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            DispatchQueue.main.async {
                self.tblChat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.cnsBottomTV.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    
    
    @objc func timerRun() {
        callGetMessageAPI()
    }
    
    @IBAction func btnSend_Action(_ sender: Any) {
        callSendMessageAPI()
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        if isNotification {
            (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func callSendMessageAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfMessage.text!.isEmpty{
            self.showAlertView("Please enter message")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.SEND_MESSAGE
        
        let parameter : [String:AnyObject] = [
            "booking_id": booking_id as AnyObject ,
            "receiver_id": cust_id as AnyObject,
            "message": tfMessage.text! as AnyObject,
            "token":UserModel.sharedInstance().authToken! as AnyObject,
            "is_washer":1 as AnyObject
        ]
        
        print(parameter)
        APIManager.shared.requestNoLoaderPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.tfMessage.text = ""
                        
                        self.callGetMessageAPI()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetMessageAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.GET_MESSAGE
        
        let parameter : [String:String] = [
            "booking_id": booking_id,
            "token":UserModel.sharedInstance().authToken!,
            "user_type": "washer"
        ]
        
        print(parameter)
        APIManager.shared.requestNoLoaderPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        if let data = jsonObject["messageRes"] as? [[String:AnyObject]], data.count > 0{
                            self.arrDictChat = data
                            self.tblChat.reloadData()
                            
                            self.tblChat.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: true)
                        }else{
                            self.arrDictChat.removeAll()
                            self.tblChat.reloadData()
                        }
                    }
                    
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
}

extension ChatWashVC : UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDictChat.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vwHeader = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 35))
        let lblTime = UILabel(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: 35))
        lblTime.font = UIFont.boldSystemFont(ofSize: 15)
        lblTime.textAlignment = .center
        
        lblTime.text = "00-11-22"
        vwHeader.addSubview(lblTime)
        return vwHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let LeftWashCell = tableView.dequeueReusableCell(withIdentifier: "LeftWashCell", for: indexPath) as! LeftWashCell
        let RightWashCell = tableView.dequeueReusableCell(withIdentifier: "RightWashCell", for: indexPath) as! RightWashCell
        
        if (arrDictChat[indexPath.row])["is_washer"] as! Int == 0{
            
            LeftWashCell.lblMsg.text = (arrDictChat[indexPath.row])["message"] as? String
            
            
            if let createdAt = arrDictChat[indexPath.row]["created_at"] as? String, createdAt != "" {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                df.locale = Locale(identifier: "en_US_POSIX")
                df.timeZone = TimeZone(abbreviation: "UTC")
                let parsedStartDate = df.date(from: createdAt)
                
                df.dateFormat = "hh:mm a"
                df.timeZone = TimeZone.current
                LeftWashCell.lblTime.text = df.string(from: parsedStartDate!)
            }
        
            
            return LeftWashCell
        }else{
            
            RightWashCell.lblMsg.text = (arrDictChat[indexPath.row])["message"] as? String
            if let createdAt = arrDictChat[indexPath.row]["created_at"] as? String, createdAt != "" {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                df.locale = Locale(identifier: "en_US_POSIX")
                df.timeZone = TimeZone(abbreviation: "UTC")
                let parsedStartDate = df.date(from: createdAt)
                
                df.dateFormat = "hh:mm a"
                df.timeZone = TimeZone.current
                RightWashCell.lblTime.text = df.string(from: parsedStartDate!)
            }
            
            if let flag = arrDictChat[indexPath.row]["flag"] as? String, flag == "read" {
                RightWashCell.ivTick.image = UIImage(named: "read_white")
            }else {
                RightWashCell.ivTick.image = UIImage(named: "unread_white")
            }
            
            return RightWashCell
        }
        
    }
    
    
}
