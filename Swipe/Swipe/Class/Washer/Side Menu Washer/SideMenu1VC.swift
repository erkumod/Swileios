//
//  SideMenuVC.swift

import UIKit
import TransitionButton

//UITableViewCell for side menu items
class SideMenuOption1 : UITableViewCell {
    @IBOutlet weak var lblTitleCell: UILabel!
    @IBOutlet weak var ivPic: UIImageView!
}

//Class for side menu.
class SideMenu1VC : UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var ivUserImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblVeiwSideMenu: UITableView!
    
    @IBOutlet weak var ivRightSwipe: UIImageView!
    @IBOutlet weak var btnSwipe: TransitionButton!
    
    //MARK:- Global Variables
    var arrOptions = ["Earnings", "Swipe Box", "Notifications","Support"]
    var arrImg = ["earning","swipe","notification","support"]
    var flag = false
    
    //MARK:- View LifeCycle Method
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
        
        let swipeRight = UIPanGestureRecognizer(target: self, action: #selector(Swiped))
        self.ivRightSwipe.addGestureRecognizer(swipeRight)
    }
    
    @objc func Swiped(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        if (gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed) && !flag {
            
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.x)
            
            if(gestureRecognizer.view!.center.x < btnSwipe.frame.width) && !flag{
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x  + translation.x, y: gestureRecognizer.view!.center.y)
                print("moving")
            }else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y:gestureRecognizer.view!.center.y)
                print("reached")
                flag = true
                
                btnSwipe.startAnimation() // 2: Then start the animation when the user tap the button
                btnSwipe.disabledBackgroundColor = UIColor.white
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    sleep(UInt32(2.0))
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.btnSwipe.stopAnimation(animationStyle: .normal, completion: {
                            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "ExitVC") as? ExitVC
                            self.sideMenuController()?.setContentViewController(next1!)
                        })
                    })
                })
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func btnEditProfile_Action(_ sender: Any) {
        let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        sideMenuController()?.setContentViewController(next1!)
    }
    
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
    }
    
    //MARK:- WebService Calling
}

extension SideMenu1VC : UITableViewDelegate,UITableViewDataSource{
    
    //Datasource method. Used to provide number of items for side menu options.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrOptions.count
    }
    
    //Datasource method. Used to provide each cell items text and images for side menu options.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOption1", for: indexPath ) as! SideMenuOption1
        cell.lblTitleCell.text = arrOptions[indexPath.row]
        cell.ivPic.image = UIImage(named: arrImg[indexPath.row])
        return cell
    }
    
    //Delegate Method. Automatically executed when user select any item from side menu options.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let next1 = self.storyboard?.instantiateViewController(withIdentifier: "EarningVC") as? EarningVC
            sideMenuController()?.setContentViewController(next1!)
            break
        default: break

        }
    }
}
