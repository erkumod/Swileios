//
//  SwipeBoxDetailVC.swift
//  Swipe
//
//  Created by My Mac on 12/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class SwipeBoxDetailVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
