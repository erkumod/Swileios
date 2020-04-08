//
//  WalletVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit


class WalletCell : UITableViewCell{
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var ivCard: CustomImageView!
    @IBOutlet weak var lbPrimary: UILabel!
    
}

class WalletVC: Main {
    
    //MARK:- Outlets
    @IBOutlet weak var tblWallet: CustomUITableView!
    @IBOutlet weak var consCardHeight: NSLayoutConstraint!
    
    //MARK:- Global Variables
    var comeFrom = ""
    var arrCardData = [[String:AnyObject]]()
    var tempDictData = [String:AnyObject]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblWallet.tableFooterView = UIView()
        if comeFrom == "side_menu"{
            consCardHeight.constant = 30
            
        }else{
            consCardHeight.constant = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetCardListAPI()
//        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
    }
    
    //MARK:- Button Actions
    @IBAction func btnClose_ACtion(_ sender: Any) {
        
        if comeFrom == "side_menu"{
            
            (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func btnAdd_Card_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    //MARK:- Webservices
    func callGetCardListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VIEW_CARD
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["my_cards"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrCardData = data
                    self.tblWallet.reloadData()
                }else{
                    self.arrCardData.removeAll()
                    self.tblWallet.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit"{
            let vc = segue.destination as! ViewDeleteCardVC
            vc.dictData = self.tempDictData
        }
    }
}

extension WalletVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        
        //let last4 = String(a.characters.suffix(4))
        
        let card_no = (arrCardData[indexPath.row])["card_no"] as! String
        cell.lblNo.text = String(card_no.suffix(4))
        
        if let isPrimary = (arrCardData[indexPath.row])["primary"] as? String, isPrimary == "1" {
            cell.lbPrimary.isHidden = false
        }else {
            cell.lbPrimary.isHidden = true
        }
        
        let card_Type = (arrCardData[indexPath.row])["type"] as! String
        
        if card_Type == "visa"{
            cell.ivCard.image = UIImage(named: "color_visa")
        }else if card_Type == "master"{
            cell.ivCard.image = UIImage(named: "color_master")
        }else if card_Type == "american"{
            cell.ivCard.image = UIImage(named: "color_american")
        }else if card_Type == "dinerclub"{
            cell.ivCard.image = UIImage(named: "dinersclub")
        }else if card_Type == "discover"{
            cell.ivCard.image = UIImage(named: "discover")
        }else if card_Type == "jcb"{
            cell.ivCard.image = UIImage(named: "jcb")
        }else{
            cell.ivCard.image = UIImage(named: "default_card_new")
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comeFrom == "side_menu"{
            self.tempDictData = arrCardData[indexPath.row]
            self.performSegue(withIdentifier: "toEdit", sender: nil)
        }else{
            UserModel.sharedInstance().selectedCardID = "\((arrCardData[indexPath.row])["id"] as! Int)"
            UserModel.sharedInstance().selectedCardName = (arrCardData[indexPath.row])["card_no"] as! String
            UserModel.sharedInstance().synchroniseData()
            
            NotificationCenter.default.post(name: Notification.Name("profile_updated"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
}
