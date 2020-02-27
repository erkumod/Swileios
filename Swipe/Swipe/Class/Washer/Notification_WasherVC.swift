//
//  Notification_WasherVC.swift
//  Swipe
//
//  Created by My Mac on 01/12/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class NotificationWasherCell : UITableViewCell{
    
}

class Notification_WasherVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }
    
}
extension Notification_WasherVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationWasherCell", for: indexPath ) as! NotificationWasherCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
