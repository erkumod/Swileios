//
//  ExitVC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ExitVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
        }
    }
    

}
