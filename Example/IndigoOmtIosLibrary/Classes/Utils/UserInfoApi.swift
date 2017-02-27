//
//  UserInfoApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary
import Alamofire

/// User info callback.
typealias UserInfoApiCallback = (_ userInfo: UserInfo?, _ error: Error?) -> ()

/// Helps fetching user info after authorization.
class UserInfoApi: FGAbstractApi {
    
    func fetchUserInfo(_ url: URL, callback: @escaping UserInfoApiCallback) {
        
        // payload to send
        let payload = FGRequestPayload(method: .get)
        payload.url = url
        
        // make request
        self.helper.send(payload) { (response: FGRequestHelperResponse<UserInfo>) in
            
            guard response.error == nil else {
                callback(nil, response.error)
                return
            }
            
            // return user info
            if let userInfo = response.value {
                callback(userInfo, nil)
            }
        }
    }
    
}

enum UserInfoApiError: Error {
    case notAuthorized(reason: String)
}
