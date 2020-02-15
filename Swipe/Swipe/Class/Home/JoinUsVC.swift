//
//  JoinUsVC.swift
//  Swipe
//
//  Created by My Mac on 26/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class JoinUsVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }

}
