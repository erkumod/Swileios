//
//  ViewDeleteVehicleVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ViewVehicleCell : UITableViewCell{
    
    @IBOutlet weak var ivPic: CustomImageView!
    @IBOutlet weak var lblBrandModel: UILabel!
    @IBOutlet weak var lblPlate: UILabel!
    @IBOutlet weak var ivMark: CustomImageView!
    @IBOutlet weak var lblPrimary: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
}

class ViewVehicleVC: Main {

    //MARK:- Outlets
    @IBOutlet weak var tblVehicle: CustomUITableView!
    @IBOutlet weak var lblCarCnt: UILabel!
    
    @IBOutlet weak var btnAddVehicle: CustomButton!
    
    //MARK:- Global Variables
    var comeFrom = ""
    var arrCarData = [[String:AnyObject]]()
    var tempDictData = [String:AnyObject]()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVehicle.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callCarListAPI()
//        (UIApplication.shared.delegate as! AppDelegate).callLoginAPI()
    }
    
    //MARK:- Button Actions
    @IBAction func btnAddVehicles_Action(_ sender: Any) {
        self.tempDictData.removeAll()
        self.performSegue(withIdentifier: "toAdd", sender: "add")
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    //MARK:- Web Service Calling
    func callCarListAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VIEW_VEHICLE
        //let params = "?email=\(tfEmail.text!)&password=\(tfPass.text!)"
        
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let data = jsonObject["my_car"] as? [[String:AnyObject]], data.count > 0{
                    
                    print(data)
                    self.arrCarData = data
                    if self.comeFrom == "side_menu"{
                        self.lblCarCnt.text = "\(self.arrCarData.count)/4 Vehicle"
                    }else{
                        self.lblCarCnt.text = ""
                    }
                    
                    if self.arrCarData.count >= 4 {
                        self.btnAddVehicle.isUserInteractionEnabled = false
                        self.btnAddVehicle.backgroundColor = UIColor(hexString: "#9a9a9a")
                    }else {
                        self.btnAddVehicle.isUserInteractionEnabled = true
                        self.btnAddVehicle.backgroundColor = UIColor(hexString: "#4EB8F5")
                    }
                    
                    self.tblVehicle.reloadData()
                    
                }else{
                    self.arrCarData.removeAll()
                    self.tblVehicle.reloadData()
                    if self.comeFrom == "side_menu"{
                        self.lblCarCnt.text = "0/4 Vehicle"
                    }else{
                        self.lblCarCnt.text = ""
                    }
                    self.btnAddVehicle.isUserInteractionEnabled = true
                    self.btnAddVehicle.backgroundColor = UIColor(hexString: "#4EB8F5")
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd"{
            let vc = segue.destination as! AddEditVehicleVC
            vc.comeFrom = sender as! String
            vc.dictData = self.tempDictData
        }
    }
}

extension ViewVehicleVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCarData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewVehicleCell", for: indexPath) as! ViewVehicleCell
        
        cell.lblBrandModel.text = "\( (arrCarData[indexPath.row])["brand_name"] as! String ) \( (arrCarData[indexPath.row])["model_name"] as! String )"
        
        cell.lblPlate.text = (arrCarData[indexPath.row])["vehicle_no"] as? String
        
        cell.lblCarType.text = (arrCarData[indexPath.row])["type"] as? String
        
        if (arrCarData[indexPath.row])["primary"] as? Int == 1{
            cell.lblPrimary.text = "Primary"
        }else{
            cell.lblPrimary.text = ""
        }
        
        if let carImage = arrCarData[indexPath.row]["car_image"] as? String {
            cell.ivPic.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(carImage)"))
        }
        
        if (arrCarData[indexPath.row])["color_code"] as? String != nil{
            cell.ivMark.backgroundColor = UIColor(hexString: (arrCarData[indexPath.row])["color_code"] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comeFrom == "side_menu"{
            self.tempDictData = self.arrCarData[indexPath.row]
            self.performSegue(withIdentifier: "toAdd", sender: "edit")
        }else{
            UserModel.sharedInstance().selectedVehicleName = "\( (arrCarData[indexPath.row])["brand_name"] as! String ) \( (arrCarData[indexPath.row])["model_name"] as! String) (\((arrCarData[indexPath.row])["vehicle_no"] as! String))"
            UserModel.sharedInstance().selectedVehicleID = "\( (arrCarData[indexPath.row])["car_id"] as! Int )"
            UserModel.sharedInstance().synchroniseData()
            
            NotificationCenter.default.post(name: Notification.Name("profile_updated"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
