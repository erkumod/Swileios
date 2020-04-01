//
//  WelcomeSwipeVC.swift
//  Swipe
//
//  Created by My Mac on 14/11/1941 .
//  Copyright © 1941 Mahajan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class WelcomeSwipeVC: Main {
    
    //MARK:- Outlets
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //lblOr.text = "Login".localize
        GIDSignIn.sharedInstance().presentingViewController = self

        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            
            let statusbarView = UIView(frame: app.statusBarFrame)
            statusbarView.backgroundColor = AppColors.cyan
            app.statusBarUIView?.addSubview(statusbarView)
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColors.cyan
        }
    }
    
    @IBAction func btnFB_Action(_ sender: UIButton) {
        let LoginManager = FBSDKLoginManager()
        LoginManager.logOut()
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            if((FBSDKAccessToken.current()) != nil){
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        if let result = result as? [String:AnyObject]{
                            let url = URL(string: "https://graph.facebook.com/\(result["id"] as! String)/picture?type=large&return_ssl_resources=1")
                            //result["email"] as! String
                            //result["id"] as! String
                            //result["name"] as! String
                            self.callSocialLoginAPI("Facebook", result["email"] as! String, result["name"] as! String, result["id"] as! String)
//                            self.callSocialLoginAPI("Facebook" as AnyObject, result["email"]  as AnyObject, result["name"]  as AnyObject, result["id"]  as AnyObject)
                        }
                    }
                })
            }
        }
    }
    
    //MARK:- Web Service Calling
    func callSocialLoginAPI(_ provider : String , _ email: String , _ name: String, _ provider_id: String) {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            CommonFunctions.shared.showToast(self.view, "Please check your internet connection")
            return
        }
        
        let serviceURL = Constant.WEBURL + Constant.API.SOCIAL_LOGIN
        
        let parameter : [String:String] = [
            "email":email ,
            "name" : name,
            "provider_id" : provider_id,
            "provider" : provider
        ]
        
        APIManager.shared.requestPostURL(serviceURL, param: parameter as [String : AnyObject] , success: { (response) in
            if let jsonObject = response.result.value as? [String:AnyObject] {
                if let status = jsonObject["success"] as? Int{
                    if status != 1{
                        print("Failed")
                        self.showAlertView(jsonObject["error"] as? String)
                    }else{
                        print(jsonObject)
                        if let data = jsonObject["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String:AnyObject] {
                                
                                UserModel.sharedInstance().user_id = "\(user["id"] as! Int)"
                                UserModel.sharedInstance().authToken = data["token"] as? String
                                
                                UserModel.sharedInstance().synchroniseData()
                                
                                (UIApplication.shared.delegate as! AppDelegate).callCheckWasherAPI()
                                (UIApplication.shared.delegate as? AppDelegate)?.callProfileInfoAPI()
                                (UIApplication.shared.delegate as? AppDelegate)?.ChangeToHome()
                                
                            } else {
                                self.showAlertView("Someting went wrong")
                            }
                        } else {
                            self.showAlertView("Someting went wrong")
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func btnGoogle_Action(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func btnRegister_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    @IBAction func btnLogin_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func btnTerms_Action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toStatic", sender: "terms")
    }
    
    @IBAction func btnPrivacy_Action(_ sender: UIButton) {

        self.performSegue(withIdentifier: "toStatic", sender: "policy")
    }
    
    //MARK:- Other Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatic"{
            let vc = segue.destination as! StaticPagesVC
            vc.comeFrom = sender as! String
        }
    }
    
    //MARK:- Web Service Calling
    
}

extension WelcomeSwipeVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            
            if (user != nil){
                var dict = [String : String]()
                dict["google_id"] = user.userID
                dict["token"] = user.authentication.idToken
                dict["full_name"] = user.profile.name
                dict["email"] = user.profile.email
                dict["img_url"] = user.profile.imageURL(withDimension: 200)?.absoluteString
                
                self.callSocialLoginAPI("Google", user.profile.email, user.profile.name, user.userID)
                
//                print(dict)
            }
        }
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}
