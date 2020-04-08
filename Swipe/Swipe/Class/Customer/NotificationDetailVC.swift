//
//  NotificationDetailVC.swift
//  Swipe
//
//  Created by My Mac on 19/01/1942 .
//  Copyright © 1942 Mahajan. All rights reserved.
//

import UIKit

class NotificationDetailVC: Main {

    var data = [String:AnyObject]()
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !data.isEmpty{
            print(data)
            
            if data["page"] as! String == "complete_booking"{
                lblMsg.attributedText = attributedString("Yay! Your vehicle has been cleaned!\n\nYou can rate your Shine Specialist and check out your vehicle photos in “Bookings” > “History” tab.")
            }else if data["page"] as! String == "start_wash"{
                lblMsg.attributedText = attributedString("Yes! We have found a Shine Specialist for you!\n\nYou can check your booking status in “Bookings” > “Scheduled” tab..")
            }else if data["page"] as! String == "cancle_wash"{
                lblMsg.attributedText = attributedString("Oops, seems like your booking has been cancelled by the Shine Specialist. However, we are still actively looking for another Shine Specialist for you. Hang on tight! ")
            }else if data["page"] as! String == "wash_accept"{
                lblMsg.attributedText = attributedString("Yes! We have found a shine specialist for you!\nYou can check your booking status in “Bookings” > “Scheduled” tab. ")
            }else if data["page"] as! String == "reedeem_stamp"{
                
                if (data["notification_desc"] as! String).contains("$3"){
                    lblMsg.attributedText = attributedString("Congratulations!\nYou have successfully redeemed $3 off!\nT&C applies.")
                }else{
                    lblMsg.attributedText = attributedString("Congratulations!\nYou have successfully redeemed $7 off!\nT&C applies.")
                }
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
