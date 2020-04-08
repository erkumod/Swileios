//
//  HelpCenterDetailVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class HelpCenterDetailVC: Main {

    @IBOutlet weak var lblQue: UILabel!
    var dictData = [String:AnyObject]()
    
    @IBOutlet weak var lblAns: UILabel!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var vwFeedback: UIView!
    @IBOutlet weak var vwThankYou: UIView!
    var is_voted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwFeedback.isHidden = false
        self.vwThankYou.isHidden = true
        
        if !dictData.isEmpty{
            print(dictData)
            lblQue.text = dictData["question"] as? String
            lblAns.text = dictData["answer"] as? String
            
            
            
        }
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDownVote_Action(_ sender: Any) {
       
            callUpDownVoteAPI("down")
        
    }
    
    @IBAction func btnUpVote_Action(_ sender: Any) {
      
            callUpDownVoteAPI("up")
       
    }
    
    func callUpDownVoteAPI(_ type : String) {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VOTE
        
        let parameter : [String:AnyObject] = ["vote": type as! AnyObject, "question_id" : dictData["id"] as AnyObject ,"token":UserModel.sharedInstance().authToken! as AnyObject]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                self.vwFeedback.isHidden = true
                self.vwThankYou.isHidden = false
            }
            
        }) { (error) in
            print(error)
        }
    }
    
}
