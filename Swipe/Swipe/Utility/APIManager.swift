//
//  APIManager.swift
//  Mangal House
//
//  Created by APPLE on 07/10/19.
//  Copyright © 2019 Mahajan-iOS. All rights reserved.
//

import Foundation
import Alamofire

class APIManager : NSObject {
    
    static let shared = APIManager()
    
    func requestGETURL(_ strURL: String, success:@escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        CommonFunctions.shared.showLoader()
        
        print("Service URL is : \(strURL)")
        
        Alamofire.request(URL(string: strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response: DataResponse<Any>) in
            switch response.result {
                case .success(_):
                    print("Success")
                    CommonFunctions.shared.hideLoader()
                    success(response)
                
                case .failure(let error):
                    debugPrint(error)
                    CommonFunctions.shared.hideLoader()
                    failure(error)
            }
        }
    }
    
    func requestGETURLNoLoader(_ strURL: String, success:@escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        
        print("Service URL is : \(strURL)")
        
        Alamofire.request(URL(string: strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                print("Success")
                success(response)
                
            case .failure(let error):
                debugPrint(error)
                failure(error)
            }
        }
    }
    
    func requestImageUpload(_ strURL: String, _ params:[String:String], _ image:UIImage, success:@escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        
        CommonFunctions.shared.showLoader()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let imgData = image.jpegData(compressionQuality: 0.8)
            multipartFormData.append(imgData!, withName: "image",fileName: "image.png", mimeType: "image/png")
            
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: strURL) { (result) in
            switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        CommonFunctions.shared.showLoader(Float(progress.fractionCompleted))
                    })
                    upload.responseJSON { response in
                        CommonFunctions.shared.hideLoader()
                        if response.response?.statusCode == 200 {
                            success(response)
                        }else {
                            failure(response.result.error!)
                        }
                    }
                case .failure(let encodingError):
                    CommonFunctions.shared.hideLoader()
                    failure(encodingError)
            }
        }
    }
}
