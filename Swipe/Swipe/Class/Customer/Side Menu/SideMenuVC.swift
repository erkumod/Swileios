//
//  SideMenuVC.swift

import UIKit
import Kingfisher

//UITableViewCell for side menu items
class SideMenuOption : UITableViewCell {
    @IBOutlet weak var lblTitleCell: UILabel!
    @IBOutlet weak var ivCell: UIImageView!
}

//Class for side menu.
class SideMenuVC : UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var ivUserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblVeiwSideMenu: UITableView!
    
    @IBOutlet weak var vwRightSwipe: UIView!
    @IBOutlet weak var ivRightSwipe: UIImageView!
    @IBOutlet weak var btnSwipe: UIButton!
    
    //MARK:- Global Variables
    var arrOptions = ["Wallet", "My Vehicles", "Rewards","Bookings", "Notifications", "Help Center","Join us"]
    var flag = false
  
    //MARK:- View LifeCycle Method
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
        
        setProfileData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData(notification:)), name: Notification.Name("profile_updated"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setProfileData()
    }
    
    func setProfileData() {
        if UserModel.sharedInstance().profile_image != nil{
            ivUserImage.kf.setImage(with: URL(string: "\(Constant.PHOTOURL)\(UserModel.sharedInstance().profile_image!)"))
        }
        
        if UserModel.sharedInstance().name != nil{
            lblUserName.text = UserModel.sharedInstance().name!
        }
        
        if UserModel.sharedInstance().isWasher != nil && UserModel.sharedInstance().isWasher == "1" {
            arrOptions = ["Wallet", "My Vehicles", "Rewards","Bookings", "Notifications", "Help Center"]
            let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
            self.ivRightSwipe.addGestureRecognizer(swipeRight)
            
            ivRightSwipe.isHidden = false
            btnSwipe.isHidden = false
            vwRightSwipe.backgroundColor = UIColor(red: 78/255, green: 184/255, blue: 245/255, alpha: 1.0)
        }else {
            arrOptions = ["Wallet", "My Vehicles", "Rewards","Bookings", "Notifications", "Help Center","Join us"]
            ivRightSwipe.isHidden = true
            btnSwipe.isHidden = true
            vwRightSwipe.backgroundColor = UIColor.white
        }
    }
    
    @objc func setData(notification: Notification) {
        
        setProfileData()
    }
    
    @objc func Swiped(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) && !flag {
            
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.x)
            
            if gestureRecognizer.view!.center.x <= 0{
                ivRightSwipe.center = CGPoint(x: 15 , y: gestureRecognizer.view!.center.y)
                return
            }
            
            if(gestureRecognizer.view!.center.x < btnSwipe.frame.size.width) && !flag{
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x  + translation.x, y: gestureRecognizer.view!.center.y)
                print("moving")
            }else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y:gestureRecognizer.view!.center.y)
                print("reached")
                ivRightSwipe.center = CGPoint(x: 15 , y: gestureRecognizer.view!.center.y)
                flag = true
                
//                btnSwipe.startAnimation() // 2: Then start the animation when the user tap the button
//                btnSwipe.disabledBackgroundColor = UIColor.white
//                let qualityOfServiceClass = DispatchQoS.QoSClass.background
//                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
//                backgroundQueue.async(execute: {
//                    sleep(UInt32(2.0))
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        self.btnSwipe.stopAnimation(animationStyle: .normal, completion: {
                            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EnterVC") as? EnterVC
                            self.sideMenuController()?.setContentViewController(next1!)
//                        })
//                    })
//                })
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func btnEditProfile_Action(_ sender: Any) {
        let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        sideMenuController()?.setContentViewController(next1!)
    }
    //Used to open facebook url.
    
    //MAKR:- Other Methods
    
    //Use to set the layout common things when first time screen loaded.
    func setLayout(){
        self.tblVeiwSideMenu.delegate = self
        self.tblVeiwSideMenu.dataSource = self
        self.tblVeiwSideMenu.tableFooterView = UIView()
    }
    
    //MARK:- WebService Calling
}

extension SideMenuVC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrOptions.count
    }
    
    //Datasource method. Used to provide each cell items text and images for side menu options.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOption", for: indexPath ) as! SideMenuOption
        cell.lblTitleCell.text = arrOptions[indexPath.row]
        return cell
    }
    
    //Delegate Method. Automatically executed when user select any item from side menu options.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as? WalletVC
            next1!.comeFrom = "side_menu"
            sideMenuController()?.setContentViewController(next1!)
            break
        case 1:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "ViewVehicleVC") as? ViewVehicleVC
            next1?.comeFrom = "side_menu"
            sideMenuController()?.setContentViewController(next1!)
            break
        case 2:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "RewardVC") as? RewardVC
            sideMenuController()?.setContentViewController(next1!)
            break
        case 3:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
            sideMenuController()?.setContentViewController(next1!)
            break
        case 4:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
            sideMenuController()?.setContentViewController(next1!)
            break
        case 5:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as? HelpCenterVC
            sideMenuController()?.setContentViewController(next1!)
            break
        case 6:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "JoinUsVC") as? JoinUsVC
            sideMenuController()?.setContentViewController(next1!)
            break
        default: break

        }
    }
}
