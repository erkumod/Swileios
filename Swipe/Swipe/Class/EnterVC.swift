//
//  SwitchVC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import  IHProgressHUD

class EnterVC: Main {

    override func viewDidLoad() {
        super.viewDidLoad()

        IHProgressHUD.show()
        IHProgressHUD.set(backgroundColor: .clear)
        IHProgressHUD.set(foregroundColor: .white)
        IHProgressHUD.set(ringRadius: 10)
        IHProgressHUD.set(ringThickness: 5)
        IHProgressHUD.set(infoImage: UIImage(named: "ring")!)
        IHProgressHUD.set(imageViewSize: CGSize(width: 15, height: 15))
        DispatchQueue.global(qos: .default).async(execute: {
          sleep(2)
          IHProgressHUD.dismissWithCompletion({
              (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
          })
        })
        
    }
    

   

}
