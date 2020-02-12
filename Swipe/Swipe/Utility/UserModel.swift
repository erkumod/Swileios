
//
//  UserModel.swift

import UIKit

class UserModel: NSObject, NSCoding {
    
    var user_id : String?
    var authToken: String?
    
    var firstname : String?
    var lastname : String?
    var email : String?
    var password : String?
    var profile_image : String?
    var mobileNo: String?
    var country_code : String?
    
    var address: String?
    var address1: String?
    var city: String?
    var country: String?
    var zipCode: String?
    
    var latitude: String?
    var longitude: String?

    var newsEmailNotification: Int?
    var newsPushNotification: Int?
    var orderEmailNotification: Int?
    var orderPushNotification: Int?
    
    var cartID : String?
    
    static var userModel: UserModel?
    static func sharedInstance() -> UserModel {
        if UserModel.userModel == nil {
            if let data = UserDefaults.standard.value(forKey: "UserModel") as? Data {
                let retrievedObject = NSKeyedUnarchiver.unarchiveObject(with: data)
                if let objUserModel = retrievedObject as? UserModel {
                    UserModel.userModel = objUserModel
                    return objUserModel
                }
            }
            
            if UserModel.userModel == nil {
                UserModel.userModel = UserModel.init()
            }
            return UserModel.userModel!
        }
        return UserModel.userModel!
    }
    
    override init() {
        
    }
    
    
    func synchroniseData(){
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    func removeData() {
        UserModel.userModel = nil
        UserDefaults.standard.removeObject(forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        self.authToken = aDecoder.decodeObject(forKey: "authToken") as? String
        
        self.firstname = aDecoder.decodeObject(forKey: "firstname") as? String
        self.lastname = aDecoder.decodeObject(forKey: "lastname") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.profile_image = aDecoder.decodeObject(forKey: "profile_image") as? String
        self.mobileNo = aDecoder.decodeObject(forKey: "mobileNo") as? String
        self.country_code = aDecoder.decodeObject(forKey: "country_code") as? String
        
        self.address = aDecoder.decodeObject(forKey: "address") as? String
        self.address1 = aDecoder.decodeObject(forKey: "address1") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        self.zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        
        self.newsEmailNotification = aDecoder.decodeObject(forKey: "newsEmailNotification") as? Int
        self.newsPushNotification = aDecoder.decodeObject(forKey: "newsPushNotification") as? Int
        self.orderEmailNotification = aDecoder.decodeObject(forKey: "orderEmailNotification") as? Int
        self.orderPushNotification = aDecoder.decodeObject(forKey: "orderPushNotification") as? Int
        
        self.cartID = aDecoder.decodeObject(forKey: "cartID") as? String
       
        
    }
    
    func encode(with aCoder: NSCoder) {

        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.authToken, forKey: "authToken")
        
        aCoder.encode(self.firstname, forKey: "firstname")
        aCoder.encode(self.lastname, forKey: "lastname")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.profile_image, forKey: "profile_image")
        aCoder.encode(self.mobileNo, forKey: "mobileNo")
        aCoder.encode(self.country_code, forKey: "country_code")
        
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.address1, forKey: "address1")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.zipCode, forKey: "zipCode")
        
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
    
        aCoder.encode(self.newsEmailNotification, forKey: "newsEmailNotification")
        aCoder.encode(self.newsPushNotification, forKey: "newsPushNotification")
        aCoder.encode(self.orderEmailNotification, forKey: "orderEmailNotification")
        aCoder.encode(self.orderPushNotification, forKey: "orderPushNotification")
        
        aCoder.encode(self.cartID, forKey: "cartID")
        

        
    }
}
