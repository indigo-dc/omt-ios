//
//  DummyProvider.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary

class DummyProvider: FGAccessTokenProvider {
    
    func getAccessToken() -> String {
        return "token"
    }
    
    func requestNewAccessToken(_ callback: @escaping FGAccessTokenProviderCallback) {
        callback(true)
    }
    
}
