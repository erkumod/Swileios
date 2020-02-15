//
//  BookingVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class BookingCell : UITableViewCell{
    
}

class BookingVC: Main {
    
    @IBOutlet weak var btnScheduled: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblScheduledBtm: UILabel!
    @IBOutlet weak var lblHistoryBtm: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnScheduled.setTitleColor(AppColors.cyan, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblScheduledBtm.isHidden = false
        lblHistoryBtm.isHidden = true
        
        
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    @IBAction func btnScheduled_Action(_ sender: Any) {
        
        btnScheduled.setTitleColor(AppColors.cyan, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblScheduledBtm.isHidden = false
        lblHistoryBtm.isHidden = true
    }
    
    @IBAction func btnHistory_Action(_ sender: Any) {
        
        btnScheduled.setTitleColor(UIColor.lightGray, for: .normal)
        btnHistory.setTitleColor(AppColors.cyan, for: .normal)
        lblScheduledBtm.isHidden = true
        lblHistoryBtm.isHidden = false
        
    }
}
extension BookingVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath ) as! BookingCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
