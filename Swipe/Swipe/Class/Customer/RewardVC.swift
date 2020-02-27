//
//  RewardVC.swift
//  Swipe
//
//  Created by My Mac on 25/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit

class RedemptionCell : UICollectionViewCell{
    
    @IBOutlet weak var ivPic: CustomImageView!
}

class AvailableCell : UICollectionViewCell{
    
}

class HistoryCell : UICollectionViewCell{
    
}

class RewardVC: Main {

    @IBOutlet weak var consWidthScreen: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var cvRedemption: UICollectionView!
    @IBOutlet weak var cvAvailable: UICollectionView!
     @IBOutlet weak var cvHistory: UICollectionView!
    
    @IBOutlet weak var btnRedemption: UIButton!
    @IBOutlet weak var btnAvailable: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblRedemBtm: UILabel!
    @IBOutlet weak var lblAvailBtm: UILabel!
    @IBOutlet weak var lblHistoryBtm: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consWidthScreen.constant = self.view.frame.size.width
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        btnRedemption.setTitleColor(AppColors.cyan, for: .normal)
        btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
        btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
        lblRedemBtm.isHidden = false
        lblAvailBtm.isHidden = true
        lblHistoryBtm.isHidden = true
    }
    

    @IBAction func btnClose_Action(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).ChangeToHome()
    }
    
    @IBAction func btnRedemption_Action(_ sender: Any) {
        scrView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    @IBAction func btnAvailable_Action(_ sender: Any) {
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width, y:0), animated: true)
    }
    
    @IBAction func btnHistory_Action(_ sender: Any) {
        scrView.setContentOffset(CGPoint(x: self.view.frame.size.width + self.view.frame.size.width , y:0), animated: true)
    }
    
}
extension RewardVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page_Number = round(scrView.contentOffset.x / scrView.frame.size.width)
        print(page_Number)
        if page_Number == 0.0 {
            btnRedemption.setTitleColor(AppColors.cyan, for: .normal)
            btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
            btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
            lblRedemBtm.isHidden = false
            lblAvailBtm.isHidden = true
            lblHistoryBtm.isHidden = true
        }else if page_Number == 1.0 {
            btnRedemption.setTitleColor(UIColor.lightGray, for: .normal)
            btnAvailable.setTitleColor(AppColors.cyan, for: .normal)
            btnHistory.setTitleColor(UIColor.lightGray, for: .normal)
            lblRedemBtm.isHidden = true
            lblAvailBtm.isHidden = false
            lblHistoryBtm.isHidden = true
        }else if page_Number == 2.0 {
            btnRedemption.setTitleColor(UIColor.lightGray, for: .normal)
            btnAvailable.setTitleColor(UIColor.lightGray, for: .normal)
            btnHistory.setTitleColor(AppColors.cyan, for: .normal)
            lblRedemBtm.isHidden = true
            lblAvailBtm.isHidden = true
            lblHistoryBtm.isHidden = false
        }
    }
}

extension RewardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cvRedemption{
            return 9
        }else if collectionView == cvAvailable{
            return 3
        }else{
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvRedemption{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RedemptionCell", for: indexPath) as! RedemptionCell
            
//            if indexPath.row == 0{
//                cell.ivPic.backgroundColor = AppColors.cyan
//                cell.ivPic.image = UIImage(named: "")
//            }
            
            return cell
            
        }else if collectionView == cvAvailable{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableCell", for: indexPath) as! AvailableCell
            
           
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            
         
            return cell
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvRedemption{
            return CGSize(width: self.cvRedemption.frame.size.width / 5, height: self.cvRedemption.frame.size.width / 5)
        }else if collectionView == cvAvailable{
            return CGSize(width: self.cvAvailable.frame.size.width / 2 - 15, height: 200)
        }else{
            return CGSize(width: self.cvHistory.frame.size.width / 2 - 15, height: 200)
        }
        
    }
    
    
    
    
}
