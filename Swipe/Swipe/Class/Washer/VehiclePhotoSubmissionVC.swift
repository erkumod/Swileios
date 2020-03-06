//
//  VehiclePhotoSubmissionVC.swift
//  Swipe
//
//  Created by My Mac on 06/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class VehiclePhotoSubmissionVC: Main {

    var isComeFrom = ""
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lblVw1: UILabel!
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var lblVw2: UILabel!
    @IBOutlet var vwAlert: CustomUIView!
    @IBOutlet weak var blurView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //self.vwAlert.frame = CGRect(x: 15, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 30, height: 181)
        
        if isComeFrom == "cakemud"{
            vw1.isHidden = false
            vw2.isHidden = true
            lblVw1.text = "View of affected area that is heavily caked in mud"
            
        }else{
            vw1.isHidden = false
            vw2.isHidden = false
            lblVw1.text = "Front view of vehicle with number plate"
            lblVw2.text = "Back view of vehicle with number plate"
        }
        
        self.view.addSubview(vwAlert)
        self.vwAlert.center = self.view.center
        
        self.vwAlert.isHidden = true
        self.blurView.isHidden = true
        
    }

    @IBAction func btnBack_ACtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
