//
//  Constants.swift

import Foundation
import UIKit

struct AppColors {

    static let cyan = UIColor(red: CGFloat(78/255.0), green: CGFloat(184/255.0), blue: CGFloat(245/255.0), alpha: 1.0)

}

public class Helper {
    public class var isIpad:Bool {
        if #available(iOS 8.0, *) {
            return UIScreen.main.traitCollection.userInterfaceIdiom == .pad
        } else {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    public class var isIphone:Bool {
        if #available(iOS 8.0, *) {
            return UIScreen.main.traitCollection.userInterfaceIdiom == .phone
        } else {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
    }
}

struct Fonts {
    static func Regular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeueCE-Roman", size: fontSize)!
    }
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

class Constant {
    static var WEBURL="https://hosting1945589.online.pro/pizzavital/webservices/"
    static var web_url_content=""
    static var web_url_common=""
    static var PROJECT_NAME = "Pizza Vital" as NSString
    static var defaults = UserDefaults.standard
    
    static var FBShareURL = ""
    static var InstaShareURL = ""
    static var MagalHouseWebURL = ""
    
    struct API {
        static var LOGIN = "login.php"
        static var REGISTER = "register.php"
        static var FORGOT_PASSWORD = "forgot_password.php"
        static var STAIC_PAGE = "static_page.php"
        static var MENU_CATEGORY = "menu_category.php"
        static var MENU_ITEM = "menu_items.php"
        static var ADD_TO_CART = "add_to_cart.php"
        static var ITEM_DETAIL = "item_details.php"
        static var CONTACT_US = "contact.php"
        static var SAVE_ADDRESS = "save_user_address.php"
        static var ADDRESS_DETAIL = "address_detail.php"
        static var GET_ADDRESS = "address_list.php"
        static var DELETE_ADDRESS = "delete_user_address.php"
        static var ORDER_HISTORY = "order_history.php"
        static var CART_ITEM = "cart_items.php"
        static var EDIT_PROFILE = "change_user_profile.php"
        static var QUANTITY = "change_quantity.php"
        static var CHECKOUT = "checkout.php"
        static var SCHEDULE = "schedule.php"
        static var LOG_OUT = "logout.php"
        static var ORDER_DETAIL = "order_detail.php"
        static var ADD_RECORD = "add_record.php"
    }
}

func setFooterView(message: String) -> UIView {
    let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 200))
    let lblMessage = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 200))
    lblMessage.textColor = UIColor.lightGray
    lblMessage.font = UIFont(name: "HelveticaNeueCE-Roman", size: 17)
    lblMessage.textAlignment = .center
    lblMessage.text = message
    viewFooter.addSubview(lblMessage)
    return viewFooter
}
