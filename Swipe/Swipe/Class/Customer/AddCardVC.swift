//
//  AddCardVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class AddCardVC: Main, UIPickerViewDataSource, UIPickerViewDelegate  {


    @IBOutlet weak var tfCardNumber: CustomTextField!
    @IBOutlet weak var tfName: CustomTextField!
    @IBOutlet weak var tfCVV: CustomTextField!
    @IBOutlet weak var tfExpiry: CustomTextField!
    @IBOutlet weak var imgCard : UIImageView!
    @IBOutlet weak var topPickerView: UIPickerView!
    @IBOutlet weak var swtPrimary: UISwitch!
    var year = [Int]()
    var month = [Int]()
    
    let anotherPicker = UIPickerView()
    var selectedMonth = 0
    var selectedYear = 0
    
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swtPrimary.layer.cornerRadius = 16
        
        for i in 1...12 {
            month.append(i)
        }
        
        let date = Date() // gets current date
        let calendar = Calendar.current
        var currentYear = calendar.component(.year, from: date) // gets current year (i.e. 2017)
        
        for i in 1...12 {
            month.append(i)
        }
        print(month)
        selectedMonth = month[0]
        
        for _ in 1...50 {
            year.append(currentYear)
            currentYear += 1
        }
        selectedYear = year[0]
        
        createAnotherPicker()
        
        
    }
    
    @IBAction func btnSave_Action(_ sender: Any) {
        self.view.endEditing(true)
        callAddCardAPI()
    }
    
    @objc func closePickerView() {
        view.endEditing(true)
        tfExpiry.text = "\(String(format: "%02d", selectedMonth))/\(String(format: "%02d", selectedYear))"
    }
    
    func createAnotherPicker() {
        anotherPicker.delegate = self
        anotherPicker.delegate?.pickerView?(anotherPicker, didSelectRow: 0, inComponent: 0)
        tfExpiry.inputView = anotherPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(AddCardVC.closePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        tfExpiry.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return month.count
        }else{
            return year.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(format: "%02d", month[row])
        }
        else{
            return "\(year[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == 0 {
            print(month[row])
            selectedMonth = month[row]
        }else{
            print(year[row])
            selectedYear = year[row]
        }
        
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == tfCardNumber) {
            let card_number = textField.text!
            if card_number.isVisaCard {
                imgCard.image = UIImage(named: "color_visa")
                status = "visa"
            }else if card_number.isMasterCard {
                imgCard.image = UIImage(named: "color_master")
                status = "master"
            }else if card_number.isExpressCard {
                imgCard.image = UIImage(named: "color_american")
                status = "american"
            }else if card_number.isDinerClubCard {
                imgCard.image = UIImage(named: "dinersclub")
                status = "dinerclub"
            }else if card_number.isDiscoverCard {
                imgCard.image = UIImage(named: "discover")
                status = "discover"
            }else if card_number.isJCBCard {
                imgCard.image = UIImage(named: "jcb")
                status = "jcb"
            }else {
                imgCard.image = UIImage(named: "default_card_new")
                status = ""
            }
            
            //        String regJCB = "^(?:2131|1800|35\\d{3})\\d{11}$";
         
            //        } else if (card_number.matches(regJCB)) {
            //            iv_card_logo.setImageResource(R.drawable.jcb);
            //            type = "jcb";
            //        } else {
            //            iv_card_logo.setImageResource(R.drawable.default_card);
            //        }
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
            
            
        }else if textField == tfCVV{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 3
        }
        
        return true
    }
    
    func callAddCardAPI() {
        self.view.endEditing(true)
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        if tfCardNumber.text!.isEmpty{
            self.showAlertView("Please enter card number")
            return
        }else if tfName.text!.isEmpty{
            self.showAlertView("Please enter holder name")
            return
        }else if tfExpiry.text!.isEmpty{
            self.showAlertView("Please enter expiry date")
            return
        }else if tfCVV.text!.isEmpty{
            self.showAlertView("Please enter cvv")
            return
        }
        var card_status = ""
        var primary = 0
        if self.swtPrimary.isOn{
            primary = 1
            card_status = "Primary"
        }else{
            primary = 0
            card_status = "Not Primary"
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.VIEW_CARD
        
        let parameter : [String:String] = [
            "token": UserModel.sharedInstance().authToken!,
            "card_no": tfCardNumber.text!,
            "expiry_month": tfExpiry.text!,
            "expiry_year": tfExpiry.text!,
            "name": tfName.text!,
            "type": status,
            "status": card_status,
            "primary": "\(primary)"
        ]
        
        print(parameter)
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
    
    
    
}
