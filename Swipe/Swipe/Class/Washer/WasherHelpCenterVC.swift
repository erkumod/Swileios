//
//  HelpCenterVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherHelpCell : UITableViewCell{
    @IBOutlet weak var lblTitle: UILabel!
}

class WasherHelpCenterVC: Main {

    @IBOutlet weak var tblHelp: UITableView!
    
    var arr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblHelp.tableFooterView = UIView()
        arr = ["What is Swipe ?" , "Is my Credit/Debit card information is safe?","Do i need to meet washer?","Why isn't my booking is accepted","How long does it take from start to end ?","Topic"]
    }
    

    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }

}

extension WasherHelpCenterVC : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WasherHelpCell", for: indexPath) as! WasherHelpCell
        
        cell.lblTitle.text = arr[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
}
