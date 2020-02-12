//
//  THBlueButton.swift
//  TapHand
//
//  Created by Pradhyuman on 01/02/16.
//  Copyright © 2016 openxcell. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@objc public protocol UINavigationViewDelegate {
    @objc optional func btnNavBackTapped(btnSender : UIButton) -> Void
    @objc optional func btnNavRightTapped(Sender: UIButton) -> Void
    @objc optional func btnNavMenuTapped(Sender: UIButton) -> Void
//    @objc optional func btnNavDoneTapped(Sender: UIButton) -> Void
//    @objc optional func btnNavSettingsTapped(Sender: UIButton) -> Void
//    @objc optional func btnNavEditTapped(Sender: UIButton) -> Void
//    @objc optional func btnNavAddTapped(Sender: UIButton) -> Void
}

//@IBDesignable

class UINavigationView : UIView{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var btnNavBack : UIButton!
    var btnNavCancel : UIButton!
    var btnNavOption : UIButton!
    var btnNavDone : UIButton!
    var btnNavEdit : UIButton!
    var lblNavTitle : UILabel!
    var btnNavAdd : UIButton!
    
    internal var navigationViewDelegate: UINavigationViewDelegate?
    
    @IBInspectable var navigationTitle : String?
    
    @IBInspectable var setNavigationTitle: Bool = false{
        didSet {
            if setNavigationTitle == true{
                let lblNavTitleRect : CGRect = CGRect(x: 0, y: 30, width: (appDelegate.window?.frame.size.width)!, height: 44)
                    lblNavTitle = UILabel(frame: lblNavTitleRect)
                    lblNavTitle.textAlignment = .center
                lblNavTitle.textColor = UIColor.white
                    lblNavTitle.text = self.navigationTitle
                    self.addSubview(lblNavTitle)
//                self.insertSubview(lblNavTitle, at: 0)
            }
        }
    }
    
    @IBInspectable internal var navBackButton: Bool = false{
        didSet {
            if navBackButton == true{
                if btnNavBack == nil{
                    btnNavBack = UIButton(type: .custom)
                    btnNavBack.frame = CGRect(x: 0, y: 30, width: 44, height: 44)
                    btnNavBack.setImage(UIImage(named: "Back"), for: .normal)
                    btnNavBack.setImage(UIImage(named: "Back"), for: .highlighted)
                    btnNavBack.addTarget(self, action: #selector(self.btnBackTapped(btnSender:)), for: .touchUpInside)
                    btnNavBack.contentHorizontalAlignment = .center
                    self.addSubview(btnNavBack)
                    self.bringSubviewToFront(btnNavBack)
                }
                btnNavBack.isHidden = false
            }
        }
    }
    
    @IBInspectable internal var navMenuButton: Bool = false{
        didSet {
            if navMenuButton == true {
                btnNavOption = UIButton(type: .custom)
                btnNavOption.frame = CGRect(x: 0, y: 30, width: 44, height: 44)
                btnNavOption.setImage(UIImage(named: "Menu"), for: .normal)
                btnNavOption.setImage(UIImage(named: "Menu"), for: .highlighted)
                btnNavOption.addTarget(self, action: #selector(self.btnMenuTapped(btnSender:)), for: .touchUpInside)
                btnNavOption.contentHorizontalAlignment = .center
                btnNavOption.isHidden = false
                    self.addSubview(btnNavOption)
                self.bringSubviewToFront(btnNavOption)

            } else {
                if navMenuButton == false {
                    btnNavOption.isHidden = true
                    btnNavOption.removeFromSuperview()
                }
            }
        }
    }
    
    @IBInspectable var navRightButton: Bool = false{
        didSet {
            if navRightButton == true{
                btnNavCancel = UIButton(type: .custom)
                btnNavCancel.frame = CGRect(x: 0, y: 30, width: 44, height: 44)
                btnNavCancel.setTitle("Cancel".localize, for: .normal)
                btnNavCancel.setTitle("Cancel".localize, for: .highlighted)
                btnNavCancel.titleLabel?.textColor = UIColor.white
//                btnNavCancel.titleLabel?.font = TRFont.VerdanaRegular(16)
                btnNavCancel.contentHorizontalAlignment = .center
                btnNavCancel.addTarget(self, action: #selector(self.btnRightTapped(btnSender:)), for: .touchUpInside)
                btnNavCancel.isHidden = false
                self.addSubview(btnNavCancel)
                self.bringSubviewToFront(btnNavCancel)
            } else {
                if navRightButton == false {
                    btnNavCancel.isHidden = true
                    btnNavCancel.removeFromSuperview()
                }
            }
        }
    }
    
//    @IBInspectable var navDoneButton: Bool = false{
//        didSet {
//            if navDoneButton == true{
//
//                btnNavDone = UIButton(type: .custom)
//                btnNavDone.frame = CGRect(x: (appDelegate.window?.frame.size.width)! - 44, y: 30, width: 44, height: 44)
//                btnNavDone.setTitle("Done", for: .normal)
//                btnNavDone.setTitle("Done", for: .highlighted)
//                btnNavDone.titleLabel?.textColor = UIColor.white
////                    btnNavDone.titleLabel?.font = TRFont.VerdanaRegular(16)
//                btnNavDone.contentHorizontalAlignment = .center
//                btnNavDone.addTarget(self, action: #selector(self.btnDoneTapped(btnSender:)), for: .touchUpInside)
//                btnNavDone.isHidden = false
//                    self.addSubview(btnNavDone)
//                self.bringSubview(toFront: btnNavDone)
//            } else {
//                if navDoneButton == false {
//                    btnNavDone.isHidden = true
//                    btnNavDone.removeFromSuperview()
//                }
//            }
//        }
//    }
//
//    @IBInspectable var navEditButton: Bool = false{
//        didSet {
//            if navEditButton == true{
//                btnNavEdit = UIButton(type: .custom)
//                btnNavEdit.frame = CGRect(x:(appDelegate.window?.frame.size.width)! - 44, y: 30, width: 44, height: 44)
//                btnNavEdit.setTitle("Edit", for: .normal)
//                btnNavEdit.setTitle("Edit", for: .highlighted)
//                btnNavEdit.titleLabel?.textColor = UIColor.white
////                btnNavEdit.titleLabel?.font = TRFont.VerdanaRegular(16)
//                btnNavEdit.contentHorizontalAlignment = .center
//                btnNavEdit.addTarget(self, action: #selector(self.btnEditTapped(btnSender:)), for: .touchUpInside)
//                btnNavEdit.isHidden = false
//                self.addSubview(btnNavEdit)
//                self.bringSubview(toFront: btnNavEdit)
//            } else {
//                if navEditButton == false {
//                    btnNavEdit.isHidden = true
//                    btnNavEdit.removeFromSuperview()
//                }
//            }
//        }
//    }
//
//    @IBInspectable var navAddButton: Bool = false{
//        didSet {
//            if navAddButton == true{
//                btnNavAdd = UIButton(type: .custom)
//                btnNavAdd.frame = CGRect(x:(appDelegate.window?.frame.size.width)! - 44, y: 30, width: 44, height: 44)
//                btnNavAdd.setTitle("Add", for: .normal)
//                btnNavAdd.setTitle("Add", for: .highlighted)
//                btnNavAdd.titleLabel?.textColor = UIColor.white
////                btnNavAdd.titleLabel?.font = TRFont.VerdanaRegular(16)
//                btnNavAdd.contentHorizontalAlignment = .center
//                btnNavAdd.addTarget(self, action: #selector(self.btnAddTapped(btnSender:)), for: .touchUpInside)
//                btnNavAdd.isHidden = false
//                self.addSubview(btnNavAdd)
//                self.bringSubview(toFront: btnNavAdd)
//            } else {
//                if navAddButton == false {
//                    btnNavAdd.isHidden = true
//                    btnNavAdd.removeFromSuperview()
//                }
//            }
//        }
//    }
//
//    @IBInspectable internal var navSettingButton: Bool = false{
//        didSet {
//            let btnNavSettings = UIButton(type: .custom)
//            btnNavSettings.frame = CGRect(x: 0, y: 30, width: 44, height: 44)
//            btnNavSettings.setImage(UIImage(named: "Settings"), for: .normal)
//            btnNavSettings.setImage(UIImage(named: "Settings"), for: .highlighted)
//            btnNavSettings.addTarget(self, action: #selector(self.btnSettingsTapped(btnSender:)), for: .touchUpInside)
//            btnNavSettings.contentHorizontalAlignment = .center
//            self.addSubview(btnNavSettings)
//            self.bringSubview(toFront: btnNavSettings)
//
//        }
//    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                self.backgroundColor = UIColor.red
    }
    
    override func draw(_ rect: CGRect) {
        //funcInit()
    }
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//
//       // funcInit()
//    }
    
    @IBAction func btnBackTapped(btnSender : UIButton){
        self.navigationViewDelegate?.btnNavBackTapped!(btnSender: btnSender)
    }
    
    @IBAction func btnRightTapped(btnSender : UIButton){
        self.navigationViewDelegate?.btnNavRightTapped!(Sender: btnSender)
    }
    
    @IBAction func btnMenuTapped(btnSender : UIButton){
        self.navigationViewDelegate?.btnNavMenuTapped!(Sender: btnSender)
    }
    
//    @IBAction func btnDoneTapped(btnSender : UIButton){
//        self.navigationViewDelegate?.btnNavDoneTapped!(Sender: btnSender)
//    }
//
//    @IBAction func btnSettingsTapped(btnSender : UIButton){
//        self.navigationViewDelegate?.btnNavSettingsTapped!(Sender: btnSender)
//    }
//
//    @IBAction func btnEditTapped(btnSender : UIButton){
//        self.navigationViewDelegate?.btnNavEditTapped!(Sender: btnSender)
//    }
//
//    @IBAction func btnAddTapped(btnSender : UIButton){
//        self.navigationViewDelegate?.btnNavAddTapped!(Sender: btnSender)
//    }
}
