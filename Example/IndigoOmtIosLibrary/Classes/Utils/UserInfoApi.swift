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

typealias UserInfoApiCallback = (_ userInfo: UserInfo?, _ error: FGFutureGatewayError?) -> ()

class UserInfoApi: FGAbstractApi {
    
    func fetchUserInfo(_ url: URL, callback: @escaping UserInfoApiCallback) {
        
        // remote
        manager.request(url).validate().responseObject(queue: self.queue) { (response: DataResponse<UserInfo>) in
            
            guard response.error == nil else {
                callback(nil, FGFutureGatewayError.network(error: response.error!))
                return
            }
            
            // return user info
            if let userInfo = response.result.value {
                callback(userInfo, nil)
            }
        }
    }
    
}
