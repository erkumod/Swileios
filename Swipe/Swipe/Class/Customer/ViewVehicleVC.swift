//
//  ViewDeleteVehicleVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ViewVehicleCell : UITableViewCell{
    
}

class ViewVehicleVC: Main {

    @IBOutlet weak var tblVehicle: CustomUITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblVehicle.tableFooterView = UIView()
    }
    
    @IBAction func btnAddVehicles_Action(_ sender: Any) {
        self.performSegue(withIdentifier: "toAdd", sender: "add")
    }
    
    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd"{
            let vc = segue.destination as! AddEditVehicleVC
            vc.comeFrom = sender as! String
        }
    }

}

extension ViewVehicleVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewVehicleCell", for: indexPath) as! ViewVehicleCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toAdd", sender: "edit")
    }
    
    
    
}
