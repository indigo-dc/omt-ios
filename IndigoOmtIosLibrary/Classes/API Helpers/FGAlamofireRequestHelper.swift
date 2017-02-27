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
    
    public func send<Value: FGObjectSerializable>(_ payload: FGRequestPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        
        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept
        
        // make request with validation
        self.manager
            .request(payload)
            .validate()
            .validate(contentType: accept)
            .responseObject(queue: self.getBackgroundQueue())
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

extension FGAbstractPayload: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        return try self.toURLRequest()
    }
    
}
