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
import GoogleSignIn
import FBSDKLoginKit
import UserNotifications
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var deviceTokenString: String!
    var navigationController : UINavigationController?
    var storyboard:UIStoryboard? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        callProfileInfoAPI()
        callLoginAPI()
   
        Stripe.setDefaultPublishableKey("pk_test_o2peB2fp7fQVVqcSnRjU3m6d0092scQ5Dr")
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
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "148617659964-3ep0o4idf88fbcckvu73oveudncv9at3.apps.googleusercontent.com"
        
        registerForRemoteNotification()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if UserModel.sharedInstance().user_id == nil{
            ChangeToLogin()
        }else{
            callCheckWasherAPI()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.description.hasPrefix("fb") {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        if url.description.hasPrefix("google"){
            
            return (GIDSignIn.sharedInstance()?.handle(url))!
            

        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        if url.description.hasPrefix("fb") {
           return FBSDKApplicationDelegate.sharedInstance().application(application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        }
        
        if url.description.hasPrefix("google"){
            
            return GIDSignIn.sharedInstance().handle(url)
            
        }
        return true
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
//                                self.callAddTokenAPI()
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
                    
                    if let stripe_cust_key = profile["customer_key"] as? String {
                        UserModel.sharedInstance().stripeCustId = stripe_cust_key
                    }
                    
                    if let car = profile["primary_car"] as? [String:AnyObject], !car.isEmpty{
                        UserModel.sharedInstance().primary_car = car
                    }
                    
                    if let card = profile["primary_card"] as? [String:AnyObject], !card.isEmpty{
                        UserModel.sharedInstance().primary_card = card
                        UserModel.sharedInstance().user_id = card["user_id"] as? String
                    }
                    
                    
                    if let bank = profile["washer"] as? [String:AnyObject], !bank.isEmpty{
                        UserModel.sharedInstance().account_number = bank["account_number"] as? String
                        UserModel.sharedInstance().account_holder = bank["account_holder"] as? String
                        UserModel.sharedInstance().bank_image = bank["image"] as? String
                        UserModel.sharedInstance().bank_name = bank["bank_name"] as? String
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
                        if let is_Started = jsonObject["is_startedWash"] as? Int, is_Started > 0 {
                            UserModel.sharedInstance().started_Booking_id = "\(is_Started)"
                            UserModel.sharedInstance().synchroniseData()
                            self.ChangeToWasher()
                        }else{
                            UserModel.sharedInstance().started_Booking_id = nil
                            UserModel.sharedInstance().synchroniseData()
                            self.ChangeToHome()
                        }
                        UserModel.sharedInstance().isWasher = "1"
                    }else {
                        UserModel.sharedInstance().started_Booking_id = nil
                        UserModel.sharedInstance().synchroniseData()
                        self.ChangeToHome()
                        UserModel.sharedInstance().isWasher = "0"
                    }
                }else {
                    UserModel.sharedInstance().started_Booking_id = nil
                    UserModel.sharedInstance().synchroniseData()
                    UserModel.sharedInstance().isWasher = "0"
                }
                UserModel.sharedInstance().synchroniseData()
                NotificationCenter.default.post(name: Notification.Name("profile_updated"), object: nil)
            }else {
                UserModel.sharedInstance().isWasher = "0"
                UserModel.sharedInstance().started_Booking_id = nil
                UserModel.sharedInstance().synchroniseData()
                UserModel.sharedInstance().synchroniseData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func callAddTokenAPI() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.SET_NOTIFICATION
        
        if UserModel.sharedInstance().deviceTokenString == nil {
            return
        }else if UserModel.sharedInstance().deviceTokenString! == "" {
            return
        }
        
        if UserModel.sharedInstance().authToken == nil{
            return
        }
        
        let parameter : [String:AnyObject] =
            [
                "user_id":UserModel.sharedInstance().user_id! as AnyObject ,
                "notification_token" : UserModel.sharedInstance().deviceTokenString! as AnyObject,
                "os":"ios" as AnyObject,
                "token": UserModel.sharedInstance().authToken! as AnyObject
        ]
        print(parameter)
        APIManager.shared.requestNoLoaderPostURL(serviceURL, param: parameter , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["status"] as? Int{
                    if status != 200{
                        print("Failed")
                    }else{
                        print("Device token Added")
                        print(jsonObject)
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self as UNUserNotificationCenterDelegate
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    //MARK:- push notification delegate methods
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//        let token = tokenParts.joined()
//        deviceTokenString = token
        
        
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Device token  : \(token)")
        if token == ""{
            print("Device token fail")
        }
        UserModel.sharedInstance().deviceTokenString = token
        UserModel.sharedInstance().synchroniseData()
        if UserModel.sharedInstance().authToken != nil {
            callAddTokenAPI()
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification data: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print notification payload data
        print("Push notification received: \(data)")
        let aps = data["aps"] as! [String: AnyObject]
        let badgeNo = aps["badge"]
        let message = aps["alert"] as! String
        print(aps)
        //let badgeValue: Int = Int((badgeNo as! NSString).intValue)
        UIApplication.shared.applicationIconBadgeNumber = badgeNo as! Int
        if (application.applicationState == .active) {
//            var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
//            topWindow?.rootViewController = UIViewController()
//            let alertController = UIAlertController(title: Constant.PROJECT_NAME as String, message: message, preferredStyle: .alert)
//            let btnCancelAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
//                topWindow?.isHidden = true
//                topWindow = nil
//            }
//            alertController.addAction(btnCancelAction)
//            topWindow?.makeKeyAndVisible()
//            topWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        else{
            if UserModel.sharedInstance().user_id != nil{
                
                if let page = data["page"] as? String{
                    
                    if page == "washer_chat"{
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController2 = mainStoryboard.instantiateViewController(withIdentifier: "ChatCustVC") as! ChatCustVC
                        viewController2.isNotification = true
                        
                        if let payload = data["payload"] as? [String:AnyObject] {
                            viewController2.booking_id = "\(payload["booking_id"] as! Int)"
                            viewController2.washer_id = "\(payload["user_id"] as! Int)"
                            viewController2.washerName = payload["user_name"] as! String
                        }
                        
                        
                        self.navigationController = UINavigationController .init(rootViewController: viewController2)
                        self.window?.rootViewController = self.navigationController
                    }else if page == "customer_chat"{
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController2 = mainStoryboard.instantiateViewController(withIdentifier: "ChatWashVC") as! ChatWashVC
                        viewController2.isNotification = true
                        
                        if let payload = data["payload"] as? [String:AnyObject] {
                            viewController2.booking_id = "\(payload["booking_id"] as! Int)"
                            viewController2.cust_id = "\(payload["user_id"] as! Int)"
                            viewController2.custName = payload["user_name"] as! String
                        }
                        
                        
                        self.navigationController = UINavigationController .init(rootViewController: viewController2)
                        self.window?.rootViewController = self.navigationController
                    }else if page == "check_washer"{
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController2 = mainStoryboard.instantiateViewController(withIdentifier: "Booking_washer_VC") as! Booking_washer_VC
                        viewController2.isNotification = true
                        self.navigationController = UINavigationController .init(rootViewController: viewController2)
                        self.window?.rootViewController = self.navigationController
                    } else {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController2 = mainStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                        viewController2.isNotification = true
                        self.navigationController = UINavigationController .init(rootViewController: viewController2)
                        self.window?.rootViewController = self.navigationController
                    }
                    
                }else{
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController2 = mainStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                    viewController2.isNotification = true
                    self.navigationController = UINavigationController .init(rootViewController: viewController2)
                    self.window?.rootViewController = self.navigationController
                }
                
            }else{
                ChangeToLogin()
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        
    }
    
}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
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
