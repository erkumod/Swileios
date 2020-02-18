//
//  EarningVC.swift
//  Swipe
//
//  Created by My Mac on 29/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class CalenderCell : UICollectionViewCell{
    
}

class EarningCell : UITableViewCell{
    
}

class EarningVC: Main {

    @IBOutlet weak var btnDaily: CustomButton!
    @IBOutlet weak var btnWeekly: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBack_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToWasher()
    }

    @IBAction func btnDaily_Action(_ sender: Any) {
        btnDaily.backgroundColor = AppColors.cyan
        btnWeekly.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnWeekly_Action(_ sender: Any) {
        btnWeekly.backgroundColor = AppColors.cyan
        btnDaily.backgroundColor = UIColor.clear
    }
}

extension EarningVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath) as! EarningCell
        
        return cell
    }
    
    
    
    
}

extension EarningVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderCell", for: indexPath) as! CalenderCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width / 6, height: 70)
        
    }
    
}
