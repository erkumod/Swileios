//
//  WasherProfileVC.swift
//  Swipe
//
//  Created by My Mac on 05/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WasherProfileVC: Main {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
 
        
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }
    
    @IBAction func btnEmailAddress_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetail", sender: "email")
    }
    
    @IBAction func btnPhoneAddress_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetail", sender: "phone")
    }
    
    @IBAction func btnAccountDetail_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toBank", sender: nil)
    }
    
    @IBAction func btnTerms_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toStatic", sender: "term")
    }
    
    @IBAction func btnSpecialist_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toStatic", sender: "special")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail"{
            let vc = segue.destination as! WasherProfileDetailVC
            vc.isComeFrom = sender as! String
        }else if segue.identifier == "toStatic"{
            let vc = segue.destination as! WasherStaticPagesVC
            vc.isComeFrom = sender as! String
        }
        
    }
    
}
