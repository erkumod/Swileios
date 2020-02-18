//
//  AddVehicleVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class AddEditVehicleVC: Main {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwDelete: CustomUIView!
    @IBOutlet weak var imgBlur: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    var comeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func btnRemoveVehicle_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
    }
    
    
    @IBAction func btnRemove_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
    }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }

  

}
