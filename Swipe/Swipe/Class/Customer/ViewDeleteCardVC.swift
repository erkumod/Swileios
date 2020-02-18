//
//  ViewDeleteCardVC.swift
//  Swipe
//
//  Created by My Mac on 19/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class ViewDeleteCardVC: Main {

    @IBOutlet weak var vwDelete: CustomUIView!
    @IBOutlet weak var imgBlur: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
    
    @IBAction func btnRemoveCard_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
     @IBAction func btnRemove_Action(_ sender: Any) {
        self.vwDelete.isHidden = false
        self.imgBlur.isHidden = false
     }
    
    @IBAction func btnCancel_Action(_ sender: Any) {
        self.vwDelete.isHidden = true
        self.imgBlur.isHidden = true
    }
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


}
