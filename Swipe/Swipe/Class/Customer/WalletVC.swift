//
//  WalletVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WalletCell : UITableViewCell{
    
}

class WalletVC: Main {

    @IBOutlet weak var tblWallet: CustomUITableView!
    @IBOutlet weak var consCardHeight: NSLayoutConstraint!
    var comeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tblWallet.tableFooterView = UIView()
        if comeFrom == "side_menu"{
            consCardHeight.constant = 30
           
        }else{
            consCardHeight.constant = 0
            
        }
    }

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

}


extension WalletVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comeFrom == "side_menu"{
            self.performSegue(withIdentifier: "toEdit", sender: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    

    
}
