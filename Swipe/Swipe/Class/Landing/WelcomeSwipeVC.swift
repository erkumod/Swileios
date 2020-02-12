//
//  WelcomeSwipeVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class WelcomeSwipeVC: Main {
    
    //MARK:- Outlets
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //lblOr.text = "Login".localize
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            
            let statusbarView = UIView(frame: app.statusBarFrame)
            statusbarView.backgroundColor = AppColors.cyan
            app.statusBarUIView?.addSubview(statusbarView)
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColors.cyan
        }
    }
    
   
    
    @IBAction func btnRegister_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    @IBAction func btnLogin_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func btnTerms_Action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toStatic", sender: "terms")
    }
    
    @IBAction func btnPrivacy_Action(_ sender: UIButton) {

        self.performSegue(withIdentifier: "toStatic", sender: "policy")
    }
    
    //MARK:- Other Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatic"{
            let vc = segue.destination as! StaticPagesVC
            vc.comeFrom = sender as! String
        }
    }
    
    //MARK:- Web Service Calling
    
}
