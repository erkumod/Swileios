//
//  RPTSideMenuNavigation.swift
//  Rapt
//
//  Created by Jecky Kukadiya on 14/11/16.
//  Copyright © 2016 Jecky Kukadiya. All rights reserved.
//

import UIKit

class SideMenuNavigation: ENSideMenuNavigationController, ENSideMenuDelegate {
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    //MARK:- Other Methods
    func setLayout() {
        let sideMenuSB = UIStoryboard(name: "Main", bundle: nil)
        let VC = sideMenuSB.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: VC, menuPosition:.left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = self.view.frame.size.width * 0.75 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        sideMenu?.allowPanGesture = true
        // make navigation bar showing over side menu
        // view.bringSubviewToFront(navigationBar)
        
    }

    //MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}
