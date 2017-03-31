//
//  AuthConfig.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AppAuth

class AuthConfig: NSObject, NSCoding {

    // MARK: - properties

    var authState: OIDAuthState?
    var userInfo: UserInfo?

    // MARK: - lifecycle

    override init() {
    }

    required init?(coder aDecoder: NSCoder) {
        self.authState = aDecoder.decodeObject(forKey: "authState") as? OIDAuthState
        self.userInfo = aDecoder.decodeObject(forKey: "userInfo") as? UserInfo
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.authState, forKey: "authState")
        aCoder.encode(self.userInfo, forKey: "userInfo")
    }

}
