//
//  BankAccountVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class BankAccountVC: Main {

    @IBOutlet weak var ivBankPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivBankPhoto.isHidden = true
        
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
