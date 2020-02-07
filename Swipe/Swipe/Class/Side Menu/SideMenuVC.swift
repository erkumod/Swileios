//
//  SideMenuVC.swift

import UIKit


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
    
    //MARK:- Global Variables
    var arrOptions = ["Wallet", "My Vehicles", "Rewards","Bookings", "Notification", "Help Center"]
    
  
    //MARK:- View LifeCycle Method
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
    }
    
    //MARK:- Button Actions
    @IBAction func btnEditProfile_Action(_ sender: Any) {
        let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        sideMenuController()?.setContentViewController(next1!)
    }
    //Used to open facebook url.
    
    //MAKR:- Other Methods
    func ChangeMainRoot() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let desiredViewController = homeSB.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let snapshot:UIView = (appdel.window?.snapshotView(afterScreenUpdates: true))!
        desiredViewController.view.addSubview(snapshot)
        appdel.window?.rootViewController = desiredViewController;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
        });
    }
    
    //Use to set the layout common things when first time screen loaded.
    func setLayout(){
        self.tblVeiwSideMenu.delegate = self
        self.tblVeiwSideMenu.dataSource = self
        self.tblVeiwSideMenu.tableFooterView = UIView()
        
//        if !(UserModel.sharedInstance().profile_image?.isEmpty)!{
//            //self.ivUserImage.kf.setImage(with: URL(string: UserModel.sharedInstance().profile_image!), placeholder: UIImage(named: "user"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
//        }
//
//        if UserModel.sharedInstance().firstname != nil && !(UserModel.sharedInstance().firstname?.isEmpty)!{
//            var name = UserModel.sharedInstance().firstname!
//            if UserModel.sharedInstance().lastname != nil && !(UserModel.sharedInstance().lastname?.isEmpty)!{
//                name = "\(name) \(UserModel.sharedInstance().lastname!)"
//            }
//            lblUserName.text = name
//        }
    }
    
    //MARK:- WebService Calling
    func callLogOut() {
        
        //Checking for internet connection. If internet is not available then system will display toast message.
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection".localize)
            return
        }
        
        //Creating API request to fetch the data.
        let serviceURL = Constant.WEBURL + Constant.API.LOG_OUT
        let params = "?user_id=\(UserModel.sharedInstance().user_id!)&auth_token=\(UserModel.sharedInstance().authToken!)"
        
        //Starting process to fetch the data.
        APIManager.shared.requestGETURL(serviceURL + params, success: { (response) in
            
            //Parsing method started to parse the data.
            if let jsonObject = response.result.value as? [String:AnyObject] {
                
                //Getting status of API. If status is 0 then fetching data otherwise it will show message of failure with reason.
                if let status = jsonObject["status"] as? String {
                    //CommonFunctions.shared.showToast(self.view, jsonObject["message"] as! String)
                    if status == "0" {
                        print("Logout Failed")
                    }else {
                        print("Logout success")
//                        let email = UserModel.sharedInstance().email!
//                        let pass = UserModel.sharedInstance().password
                        UserModel.sharedInstance().removeData()
                        UserModel.sharedInstance().synchroniseData()
//                        UserModel.sharedInstance().email = email
//                        UserModel.sharedInstance().password = pass
//                        UserModel.sharedInstance().synchroniseData()
                        self.ChangeMainRoot()
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
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
//        switch indexPath.row {
//        case 0:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as? CategoryVC
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 1:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 2:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "OrderHistoryVC") as? OrderHistoryVC
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 3:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC") as? ScheduleVC
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 4:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 5:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "StaticVC") as? StaticVC
//            next1?.type = "about"
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 6:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs") as? ContactUs
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 7:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "StaticVC") as? StaticVC
//            next1?.type = "policy"
//            next1?.isComeFrom = "sidemenu"
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 8:
//            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "StaticVC") as? StaticVC
//            next1?.type = "terms"
//            next1?.isComeFrom = "sidemenu"
//            sideMenuController()?.setContentViewController(next1!)
//            break
//        case 9:
//            callLogOut()
//            UserModel.sharedInstance().removeData()
//            UserModel.sharedInstance().synchroniseData()
//            (UIApplication.shared.delegate as! AppDelegate).ChangeMain_Login()
//            break
//        default: break
//
//        }
    }
}
