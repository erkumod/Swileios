//
//  WasherNotificationDetailVC.swift
//  Swipe
//
//  Created by My Mac on 19/01/1942 .
//  Copyright © 1942 Mahajan. All rights reserved.
//

import UIKit

class WasherNotificationDetailVC: Main {

    var data = [String:AnyObject]()
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !data.isEmpty{
            print(data)
            
            if data["page"] as! String == "cancle_booking"{
                lblMsg.attributedText = attributedString("Sorry, the booking has been cancelled by vehicle owner. Please select another booking.")
            }
           
            lblHeader.text = data["notification_title"] as? String
            
            let inFormatter = DateFormatter()
            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            inFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let outFormatter = DateFormatter()
            outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            outFormatter.dateFormat = "dd-MMM-yyyy hh:mm:a"

            let inStr = data["created_at"] as! String
            let date = inFormatter.date(from: inStr)!
            let outStr = outFormatter.string(from: date)
            lblDate.text = outStr
        }
       
    }
    
    func attributedString(_ txt : String) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: txt)

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        return attributedString
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
