//
//  AppDelegate.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import IQKeyboardManager
import GoogleMaps
import GooglePlaces
//import GoogleSignIn
//import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        callProfileInfoAPI()
        callLoginAPI()
        
        GMSServices.provideAPIKey("AIzaSyDU1bIWOnYJMYCS7rvLoSRonFPdozy7QRc")
        GMSPlacesClient.provideAPIKey("AIzaSyDU1bIWOnYJMYCS7rvLoSRonFPdozy7QRc")
        
        UserModel.sharedInstance().selectedVehicleName = nil
        UserModel.sharedInstance().selectedVehicleID = nil
        UserModel.sharedInstance().selectedCardID = nil
        UserModel.sharedInstance().selectedCardName = nil
        UserModel.sharedInstance().selectedPromoCode = nil
        UserModel.sharedInstance().selectedPromoType = nil
        UserModel.sharedInstance().synchroniseData()
        
        LocationManager.sharedInstance.startLocationUpdating()
        LocationManager.sharedInstance.beginLocationUpdating()
        IQKeyboardManager.shared().isEnabled = true
        
        if UserModel.sharedInstance().user_id == nil{
            ChangeToLogin()
        }else{
            ChangeToHome()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
   

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func ChangeToLogin() {
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
    
    func ChangeToHome() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let desiredViewController = homeSB.instantiateViewController(withIdentifier: "SideMenuNavigation") as! SideMenuNavigation
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
    
    func ChangeToWasher() {
        let homeSB = UIStoryboard(name: "Main", bundle: nil)
        let desiredViewController = homeSB.instantiateViewController(withIdentifier: "WasherNavigation") as! WasherNavigation
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
    
    func callLoginAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.LOGIN
        
        if UserModel.sharedInstance().email == nil{
            return
        }
        
        if UserModel.sharedInstance().password == nil{
            return
        }
        
        let parameter : [String:AnyObject] = ["email":UserModel.sharedInstance().email! as AnyObject , "password" : UserModel.sharedInstance().password! as AnyObject]
        
        APIManager.shared.requestNoLoaderPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["success"] as? Bool{
                    if !status{
                        print("Failed")
                    }else{
                        print(jsonObject)
                        if let data = jsonObject["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String:AnyObject] {
                                UserModel.sharedInstance().user_id = "\(user["id"] as! Int)"
                                UserModel.sharedInstance().authToken = data["token"] as? String
                                UserModel.sharedInstance().synchroniseData()
                                self.callProfileInfoAPI()
                            }
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    func callProfileInfoAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
//            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        if UserModel.sharedInstance().authToken == nil{
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.PROFILE_INFO
        
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestNoLoaderGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                
                if let profile = jsonObject["profile"] as? [String:AnyObject] {
                    UserModel.sharedInstance().upvote_count = "\(profile["upvote_count"] as! Int)"
                    UserModel.sharedInstance().downvote_count = "\(profile["downvote_count"] as! Int)"
                    UserModel.sharedInstance().dob = profile["dob"] as? String
                    UserModel.sharedInstance().gender = profile["gender"] as? String
                    
                    if let car = profile["primary_car"] as? [String:AnyObject], !car.isEmpty{
                        UserModel.sharedInstance().primary_car = car
                    }
                    
                    if let card = profile["primary_card"] as? [String:AnyObject], !card.isEmpty{
                        UserModel.sharedInstance().primary_card = card
                        UserModel.sharedInstance().user_id = card["user_id"] as? String
                    }
                    
                    UserModel.sharedInstance().email = profile["email"] as? String
                    UserModel.sharedInstance().mobileNo = profile["mobile"] as? String
                    UserModel.sharedInstance().country_code = profile["country_code"] as? String
                    UserModel.sharedInstance().name = profile["name"] as? String
                    UserModel.sharedInstance().profile_image = profile["profile_pic"] as? String
                    UserModel.sharedInstance().synchroniseData()
                    NotificationCenter.default.post(name: Notification.Name("profile_updated"), object: nil)
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
//    check_washer
    func callCheckWasherAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            //            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        if UserModel.sharedInstance().authToken == nil{
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.CHECK_WASHER
        
        let parameter  = "?token=\(UserModel.sharedInstance().authToken!)"
        
        APIManager.shared.requestNoLoaderGetURL(serviceURL + parameter, success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int, status == 200 {
                    if let isWasher = jsonObject["washer"] as? Int, isWasher == 1 {
                        UserModel.sharedInstance().isWasher = "1"
                    }else {
                        UserModel.sharedInstance().isWasher = "0"
                    }
                }else {
                    UserModel.sharedInstance().isWasher = "0"
                }
                UserModel.sharedInstance().synchroniseData()
            }else {
                UserModel.sharedInstance().isWasher = "0"
                UserModel.sharedInstance().synchroniseData()
            }
        }) { (error) in
            print(error)
        }
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                statusBarView.backgroundColor = AppColors.cyan
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
