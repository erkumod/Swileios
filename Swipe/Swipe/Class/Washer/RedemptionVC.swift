//
//  RedemptionVC.swift
//  Swipe
//
//  Created by My Mac on 02/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RedemptionVC: Main {

    @IBOutlet weak var iv78: UIImageView!
    @IBOutlet weak var iv89: UIImageView!
    @IBOutlet weak var iv910: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn78_Action(_ sender: Any) {
        iv78.image = UIImage(named: "correct")
        iv89.image = nil
        iv910.image = nil
    }
    
    @IBAction func btn89_Action(_ sender: Any) {
        iv78.image = nil
        iv89.image = UIImage(named: "correct")
        iv910.image = nil
    }
    
    @IBAction func btn910_Action(_ sender: Any) {
        iv78.image = nil
        iv89.image = nil
        iv910.image = UIImage(named: "correct")
    }
    
}
