//
//  AddVehicleVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class AddEditVehicleVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwDelete: CustomUIView!
    @IBOutlet weak var imgBlur: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var tfBrandName: CustomTextField!
    @IBOutlet weak var tfCarModel: CustomTextField!
    @IBOutlet weak var tfPlate: CustomTextField!
    @IBOutlet weak var tfColor: CustomTextField!
    @IBOutlet weak var swtPrimary: UISwitch!
    
    //MARK:- Global Variables
    var dictData = [String:AnyObject]()
    
    var arrDictBrand = [[String:AnyObject]]()
    var arrBrand = [String]()
    var strBrandId = ""
    
    var arrDictColor = [[String:AnyObject]]()
    var arrColor = [String]()
    var strColorName = ""
    var strColorCode = ""
    
    var arrDictModel = [[String:AnyObject]]()
    var arrModel = [String]()
    var strModelId = ""
    
    var comeFrom = ""
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetColorAPI()
        callGetBrandAPI()
        if !dictData.isEmpty{
            self.tfBrandName.text = dictData["brand_name"] as? String
            self.tfCarModel.text = dictData["model_name"] as? String
            self.tfPlate.text = dictData["vehicle_no"] as? String
            self.tfColor.text = dictData["color_name"] as? String
            if dictData["primary"] as? Int == 1{
                swtPrimary.isOn = true
            }else{
                swtPrimary.isOn = false
            }   
            strBrandId = "\(dictData["brand_id"] as! Int)"
            strModelId = dictData["car_model"] as! String
            strColorName = dictData["color_name"] as! String
            strColorCode = dictData["color_code"] as! String
        }
        swtPrimary.layer.cornerRadius = 16
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if comeFrom == "add"{
            lblHeader.text = "Add Vehicle"
            btnDelete.isHidden = true
        }else{
            lblHeader.text = "Edit Vehicle Info"
            btnDelete.isHidden = false
        }
        
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
    
    //MARK:- Button Actions
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRemoveVehicle_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
    }
    
    @IBAction func btnRemove_Action(_ sender: UISwitch) {
        callDeleteCarAPI()
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
    
    @IBAction func btnSave_Action(_ sender: Any) {
        if comeFrom == "add"{
            callAddCarAPI()
        }else{
            callEditCarAPI()
        }
    }
    
    //MARK:- Web Services
    func callGetBrandAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.BRAND
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["brands"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrDictBrand = data
                    self.arrBrand = data.map{$0["brand_name"] as! String}
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetColorAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.COLOR
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["vehicles"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrDictColor = data
                    self.arrColor = data.map{$0["name"] as! String}
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callDeleteCarAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.DELETE_CAR
        let parameter : [String:AnyObject] = ["car_id": dictData["car_id"] as? Int as AnyObject, "token" : UserModel.sharedInstance().authToken! as AnyObject]
        APIManager.shared.requestPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.vwDelete.isHidden = true
                        self.imgBlur.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callGetModelAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.MODEL
        let parameter : [String:AnyObject] = [
            "brand_id": self.strBrandId as AnyObject,
            "token": UserModel.sharedInstance().authToken! as AnyObject
        ]
        APIManager.shared.requestPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["models"] as? [[String:AnyObject]], data.count > 0{
                    print(data)
                    self.arrDictModel = data
                    self.arrModel = data.map{$0["model_name"] as! String}
                    
                    self.strModelId = "\( (self.arrDictModel[0])["id"] as! Int )"
                    self.tfCarModel.text = (self.arrDictModel[0])["model_name"] as? String
                    
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callAddCarAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfBrandName.text!.isEmpty{
           self.showAlertView("Please select brand name")
            return
        }else if tfCarModel.text!.isEmpty{
            self.showAlertView("Please select model name")
            return
        }else if tfPlate.text!.isEmpty{
            self.showAlertView("Enter plate number")
            return
        }else if tfColor.text!.isEmpty{
            self.showAlertView("Please select color")
            return
        }
        
        var primary = 0
        if self.swtPrimary.isOn{
            primary = 1
        }else{
            primary = 0
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VIEW_VEHICLE
        
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "brand_id": strBrandId,
            "model_id": strModelId,
            "vehicle_no": tfPlate.text!,
            "car_image": "",
            "primary": "\(primary)",
            "color_name": strColorName,
            "color_code": strColorCode
        ]

        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    if let status = jsonObject["success"] as? Int{
                        if status == 0{
                            self.showAlertView(((jsonObject["error"] as! [String:AnyObject])["vehicle_no"] as! [String])[0])
                        }
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callEditCarAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfBrandName.text!.isEmpty{
            self.showAlertView("Please select brand name")
            return
        }else if tfCarModel.text!.isEmpty{
            self.showAlertView("Please select model name")
            return
        }else if tfPlate.text!.isEmpty{
            self.showAlertView("Enter plate number")
            return
        }else if tfColor.text!.isEmpty{
            self.showAlertView("Please select color")
            return
        }
        
        var primary = 0
        if self.swtPrimary.isOn{
            primary = 1
        }else{
            primary = 0
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.EDIT_VEHICLE
        
        let parameter : [String:String] = [
            "car_id": "\(dictData["car_id"] as! Int)",
            "token": UserModel.sharedInstance().authToken!,
            "brand_id": strBrandId,
            "model_id": strModelId,
            "vehicle_no": tfPlate.text!,
            "car_image": "",
            "primary": "\(primary)",
            "color_name": strColorName,
            "color_code": strColorCode
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                print(jsonObject)
                if let status = jsonObject["status"] as? Int{
                    if status == 200{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- UITextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfBrandName{
            ActionSheetStringPicker.show(withTitle: "Select Brand", rows: self.arrBrand, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                
                if values != nil{
                    self.strBrandId = "\( (self.arrDictBrand[indexes])["id"] as! Int )"
                    self.tfBrandName.text = (self.arrDictBrand[indexes])["brand_name"] as? String
                    self.callGetModelAPI()
                }
                return
            }, cancel: { ActionStringCancelBlock in
                return
            }, origin: tfBrandName)
            return false
        }else if textField == tfColor{
            self.view.endEditing(true)
            ActionSheetStringPicker.show(withTitle: "Select Color", rows: self.arrColor, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                
                if values != nil{
                    self.strColorCode = (self.arrDictColor[indexes])["code"] as! String
                    self.strColorName = (self.arrDictColor[indexes])["name"] as! String
                    self.tfColor.text = (self.arrDictColor[indexes])["name"] as? String
                }
                return
            }, cancel: { ActionStringCancelBlock in
                return
            }, origin: tfColor)
            return false
        }else if textField == tfCarModel{
            ActionSheetStringPicker.show(withTitle: "Select Model", rows: self.arrModel, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                if values != nil{
                    self.strModelId = "\( (self.arrDictModel[indexes])["id"] as! Int )"
                    self.tfCarModel.text = (self.arrDictModel[indexes])["model_name"] as? String
                }
                return
            }, cancel: { ActionStringCancelBlock in
                return
            }, origin: tfCarModel)
            return false
        }else{
            return true
        }
    }
    
}
