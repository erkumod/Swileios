//
//  EditProfileVC.swift
//  Swipe
//
//  Created by My Mac on 16/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class EditProfileVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func btnBack_Action(_ sender: Any) {
        ChangeHomeRoot()
    }
    
    @IBAction func btnLogOut_Action(_ sender: Any) {
        ChangeLoginRoot()
    }
    
    func ChangeLoginRoot() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let desiredViewController = homeSB.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let snapshot:UIView = (appdel.window?.snapshotView(afterScreenUpdates: true))!
        desiredViewController.view.addSubview(snapshot)
        appdel.window?.rootViewController = desiredViewController;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
    
    func ChangeHomeRoot() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let desiredViewController = homeSB.instantiateViewController(withIdentifier: "SideMenuNavigation") as! SideMenuNavigation
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let snapshot:UIView = (appdel.window?.snapshotView(afterScreenUpdates: true))!
        desiredViewController.view.addSubview(snapshot)
        appdel.window?.rootViewController = desiredViewController;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
}
