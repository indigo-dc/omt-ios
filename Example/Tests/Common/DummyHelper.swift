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
    var dummyErrorResponseBody: String?
    var dummyValue: Any?
    
    init() {
        
    }
    
    func getBackgroundQueue() -> DispatchQueue {
        return DispatchQueue.global()
    }
    
    public func send<Value : FGObjectSerializable>(_ payload: FGRequestPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        getBackgroundQueue().async {
            
            do {
                let _ = try payload.asURLRequest()
            }
            catch {
                
            }
            
            let response = FGRequestHelperResponse<Value>(request: nil,
                                                          response: self.dummyResponse,
                                                          data: self.dummyErrorResponseBody?.data(using: .utf8),
                                                          error: self.dummyError,
                                                          value: (self.dummyValue as? Value))
            print(payload.description)
            print(response.description)
            print(response.error as Any)
            
            callback(response)
        }
    }
    
    public func downloadFile(_ payload: FGDownloadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>) {
        getBackgroundQueue().async {
            
            do {
                let _ = try payload.asURLRequest()
            }
            catch {
                
            }
            
            let response = FGRequestHelperResponse<FGEmptyObject>(request: nil,
                                                                  response: self.dummyResponse,
                                                                  data: self.dummyErrorResponseBody?.data(using: .utf8),
                                                                  error: self.dummyError,
                                                                  value: (self.dummyValue as? FGEmptyObject))
            print(payload.description)
            print(response.description)
            print(response.error as Any)
            
            callback(response)
        }
    }
    
    public func uploadFile(_ payload: FGUploadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>) {
        getBackgroundQueue().async {
            
            do {
                let _ = try payload.asURLRequest()
            }
            catch {
                
            }
            
            let response = FGRequestHelperResponse<FGEmptyObject>(request: nil,
                                                                  response: self.dummyResponse,
                                                                  data: self.dummyErrorResponseBody?.data(using: .utf8),
                                                                  error: self.dummyError,
                                                                  value: (self.dummyValue as? FGEmptyObject))
            print(payload.description)
            print(response.description)
            print(response.error as Any)
            
            callback(response)
        }
    }
    
}
