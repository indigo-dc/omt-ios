//
//  FGAlamofireRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation
import Alamofire

/// Implementation of FGRequestHelper with Alamofire library.
public class FGAlamofireRequestHelper: FGRequestHelper {
    
    // MARK: - properties
    
    /// Session helper for Alamofire's SessionManager.
    public let session: FGSessionHelper
    
    /// Session manager.
    public let manager: SessionManager
    
    // MARK: - lifecycle
    
    public init(session: FGSessionHelper) {
        self.session = session
        self.manager = session.getSessionManager()
    }
    
    // MARK: - FGRequestHelper
    
    public func getBackgroundQueue() -> DispatchQueue {
        return session.getDispatchQueue()
    }
    
    public func send<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        
        // check url
        guard payload.url != nil else {
            
            // return error
            let error = FGFutureGatewayError.urlIsEmpty(reason: "Payload has an empty URL")
            
            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }
        
        // request url
        let url: URL = payload.url!
        
        // map method by raw value
        let method: HTTPMethod = HTTPMethod(rawValue: payload.method.rawValue) ?? HTTPMethod.get
        
        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept
        
        // make request with validation
        self.manager
            .request(url, method: method, parameters: payload.parameters, encoding: URLEncoding.default, headers: payload.headers)
            .validate()
            .validate(contentType: accept)
            .responseObject(queue: self.session.getDispatchQueue())
        { (dataResponse: DataResponse<Value>) in
            
            // create response object
            let response = FGRequestHelperResponse(request: dataResponse.request,
                                                   response: dataResponse.response,
                                                   data: dataResponse.data,
                                                   error: dataResponse.error as? FGFutureGatewayError,
                                                   value: dataResponse.value)
            
            // execute
            callback(response)
        }
    }
    
}
