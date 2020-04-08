//
//  HelpCenterVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class HelpCell : UITableViewCell{
    @IBOutlet weak var lblTitle: UILabel!
}

class HelpCenterVC: Main {

    @IBOutlet weak var tblHelp: UITableView!
    
    var arrDictFAQ = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetFAQListAPI()
        tblHelp.tableFooterView = UIView()
    }
    

    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }

    func callGetFAQListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.GET_FAQ_LIST
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [[String:AnyObject]] , jsonObject.count > 0{
                self.arrDictFAQ = jsonObject
                self.tblHelp.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let vc = segue.destination as! HelpCenterDetailVC
            vc.dictData = sender as! [String:AnyObject]
        }
    }
    
    
    
}

extension HelpCenterVC : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDictFAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell
        
        cell.lblTitle.text = (arrDictFAQ[indexPath.row])["question"] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetail", sender: arrDictFAQ[indexPath.row])
        
    }
    
}
