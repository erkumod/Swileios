//  SubClass.swift

import Foundation
import UIKit
import KMPlaceholderTextView
//import SVProgressHUD
//import Toast_Swift

class Main : UIViewController, UITextFieldDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class CommonFunctions : NSObject {
    static let shared: CommonFunctions = {
        CommonFunctions()
    }()
    
    func showLoader() {
        //SVProgressHUD.show()
    }

    func showLoader(_ withPercentage:Float) {
        //SVProgressHUD.showProgress(withPercentage)
    }

    func hideLoader() {
        //SVProgressHUD.dismiss()
    }
    
    func showToast(_ view:UIView, _ strMessage: String) {
        //view.makeToast(strMessage)
    }
}

class CustomButton: UIButton {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var RightBorder: CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async {
                let rightBorder = UIView(frame: CGRect(x: self.frame.size.width - self.RightBorder, y: 0, width: self.RightBorder, height: self.frame.size.height))
                rightBorder.backgroundColor = self.RightBorderColor
                self.addSubview(rightBorder)
            }
        }
    }
    
    @IBInspectable var RightBorderColor: UIColor = UIColor.white {
        didSet {
            
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    
    @IBInspectable var bottomBorder:CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                let border = CALayer()
                let width = self.bottomBorder
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = width
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var localizedText: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localize, for: .normal)
        }
    }
    
}

class KMTextView: KMPlaceholderTextView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

class CustomStackView: UIStackView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
}

class CustomUIView: UIView {
    
    @IBInspectable var dropShadow: Bool = false {
        didSet {
            DispatchQueue.main.async {
                let shadowPath = UIBezierPath(rect: self.bounds)
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOffset = CGSize(width: -1, height: 2.0)
                self.layer.shadowOpacity = 0.8
                self.layer.shadowPath = shadowPath.cgPath
                //self.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.Radius
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var bottomBorder: CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async {
                let border = CALayer()
                let width = self.bottomBorder
                border.borderColor = UIColor.darkGray.cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = width
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }

    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    @IBInspectable var FourSideShadow: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.FourSideShadow == true {
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                    self.setNeedsDisplay()
                    let shadowSize : CGFloat = 5.0
                    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                               y: -shadowSize / 2,
                                                               width: self.frame.size.width + shadowSize,
                                                               height: self.frame.size.height + shadowSize))
                    self.layer.masksToBounds = false
                    self.layer.shadowColor = UIColor.gray.cgColor
                    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    self.layer.shadowOpacity = 0.5
                    self.layer.shadowPath = shadowPath.cgPath
                    self.layer.shadowRadius = self.Radius
                    self.layer.cornerRadius = self.Radius
                }
            }
        }
    }
}

class CustomTextView: UITextView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

class CustomLabel: UILabel{
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
   

    
    @IBInspectable var localizedText: String? {
        get { return nil }
        set(key) {
            text = key?.localize
        }
    }

}

class CustomUITableView: UITableView {
    @IBInspectable var FooterView: UIView = UIView() {
        didSet {
            self.tableFooterView = FooterView
        }
    }
}

class CustomTextField: UITextField {
    @IBInspectable var dropShadow: Bool = false {
        didSet {
            DispatchQueue.main.async {
                let shadowPath = UIBezierPath(rect: self.bounds)
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
                self.layer.shadowOpacity = 0.5
                self.layer.shadowPath = shadowPath.cgPath
            }
        }
    }
    
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var LeftSpace: CGFloat = 0 {
        didSet {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: LeftSpace, height: self.frame.size.height))
            view.backgroundColor = UIColor.clear
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var LeftImage: UIImage? {
        didSet {
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.size.height))
            iv.image = LeftImage
            iv.contentMode = .center
            self.leftView = iv
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var RightSpace: CGFloat = 0 {
        didSet {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: RightSpace, height: self.frame.size.height))
            view.backgroundColor = UIColor.clear
            self.rightView = view
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var RightImage: UIImage? {
        didSet {
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
            iv.image = RightImage
            iv.contentMode = .center
            self.rightView = iv
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var bottomBorder:CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                let border = CALayer()
                let width = self.bottomBorder
                border.borderColor = UIColor.lightGray.cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = width
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    @IBInspectable var localizedText: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localize
            placeHolderColor = UIColor.white
        }
    }
    
}

class CustomImageView : UIImageView{
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
//            DispatchQueue.main.async {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
//                self.layoutIfNeeded()
//            }
            
        }
    }
    
    @IBInspectable var FourSideShadow: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.FourSideShadow == true {
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                    self.setNeedsDisplay()
                    let shadowSize : CGFloat = 5.0
                    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                               y: -shadowSize / 2,
                                                               width: self.frame.size.width + shadowSize,
                                                               height: self.frame.size.height + shadowSize))
                    self.layer.masksToBounds = false
                    self.layer.shadowColor = UIColor.gray.cgColor
                    self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    self.layer.shadowOpacity = 0.5
                    self.layer.shadowPath = shadowPath.cgPath
                    self.layer.shadowRadius = self.Radius
                    self.layer.cornerRadius = self.Radius
                }
            }
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}
