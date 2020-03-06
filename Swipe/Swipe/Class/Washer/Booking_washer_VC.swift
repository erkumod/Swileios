//
//  Booking_washer_VC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ConfirmedBookingCell : UITableViewCell{
    
}

class AvailableBookingCell : UITableViewCell{
    
}

class Booking_washer_VC: Main {

    @IBOutlet weak var btnConfirmed: UIButton!
    @IBOutlet weak var btnAvailable: UIButton!
    
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var consWidthScreen: NSLayoutConstraint!
    //@IBOutlet weak var consHeightScreen: NSLayoutConstraint!
    
    @IBOutlet weak var tblConfirmed: UITableView!
    @IBOutlet weak var tblAvailable: UITableView!
    var isConfirmed = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isConfirmed = true
        consWidthScreen.constant = self.view.frame.size.width
        //consHeightScreen.constant = self.view.frame.size.height - 140
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        btnConfirmed.setTitleColor(AppColors.cyan, for: .normal)
        btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
        lblConfirm.isHidden = false
        lblAvailable.isHidden = true
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
    
    @IBAction func btnSideMenu_Action(_ sender: Any) {
        toggleSideMenuView()
    }
    
    @IBAction func btnComfirmed_Action(_ sender: Any) {
        isConfirmed = true
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    @IBAction func btnAvailable_Action(_ sender: Any) {
        isConfirmed = false
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width, y:0), animated: true)
    }
    
}

extension Booking_washer_VC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page_Number = round(scrView.contentOffset.x / scrView.frame.size.width)
        print(page_Number)
        if page_Number == 0.0 {
            btnConfirmed.setTitleColor(AppColors.cyan, for: .normal)
            btnAvailable.setTitleColor(UIColor.white, for: .normal)
            lblConfirm.isHidden = false
            lblAvailable.isHidden = true
        }else if page_Number == 1.0 {
            btnConfirmed.setTitleColor(UIColor.white, for: .normal)
            btnAvailable.setTitleColor(AppColors.cyan, for: .normal)
            lblAvailable.isHidden = false
            lblConfirm.isHidden = true
            
        }
    }
}

extension Booking_washer_VC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblConfirmed{
            return 7
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblConfirmed{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmedBookingCell", for: indexPath) as! ConfirmedBookingCell
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableBookingCell", for: indexPath) as! AvailableBookingCell
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isConfirmed{
            self.performSegue(withIdentifier: "toConfirm", sender: nil)
        }else{
            self.performSegue(withIdentifier: "toAvailable", sender: nil)
        }
        
        
    }
}
