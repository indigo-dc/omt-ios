//
//  DummyHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 08.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary
import SwiftyJSON

class DummyHelper: FGRequestHelper {
    
    var dummyResponse: HTTPURLResponse?
    var dummyError: FGFutureGatewayError?
    var dummyValue: Any?
    
    init() {
        
    }
    
    func getBackgroundQueue() -> DispatchQueue {
        return DispatchQueue.global()
    }
    
    func send<Value : FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping (FGRequestHelperResponse<Value>) -> ()) {
        getBackgroundQueue().async {
            print(payload.description)
            let response = FGRequestHelperResponse<Value>(request: nil,
                                                          response: self.dummyResponse,
                                                          data: nil,
                                                          error: self.dummyError,
                                                          value: (self.dummyValue as? Value))
            print(response.description)
            
            callback(response)
        }
    }
    
}
