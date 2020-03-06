//
//  SwipeBoxVC.swift
//  Swipe
//
//  Created by My Mac on 01/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RedeemCell : UITableViewCell{
    
}

class SwipeBoxVC: Main {

    @IBOutlet weak var lblTap: CustomLabel!
    @IBOutlet weak var ivBlurView: UIImageView!
    @IBOutlet weak var vwInfo: CustomUIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ivBlurView.isHidden = true
        self.vwInfo.isHidden = true
        self.lblTap.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        ivBlurView.addGestureRecognizer(tap)
        
        ivBlurView.isUserInteractionEnabled = true
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.ivBlurView.isHidden = true
        self.vwInfo.isHidden = true
        self.lblTap.isHidden = true
    }
    
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
    
}
extension SwipeBoxVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemCell", for: indexPath ) as! RedeemCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        
    }
}
