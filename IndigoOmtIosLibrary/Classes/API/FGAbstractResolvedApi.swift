//
//  FGAbstractResolvedApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 15.02.2017.
//
//

import Foundation

/// Abstract API with resolver.
open class FGAbstractResolvedApi: FGAbstractApi {
    
    // MARK: - properties
    
    /// Authorized username for API requests
    public let username: String
    
    /// API URL resolver.
    public let resolver: FGApiResolver
    
    // MARK: - lifecycle
    
    public init(username: String, resolver: FGApiResolver, helper: FGRequestHelper) {
        self.username = username
        self.resolver = resolver
        super.init(helper: helper)
    }
    
    // MARK: - public methods
    
    /// Fetches URL from resolver, updated payload URL and sends payload
    func fetchResolvedUrlAndSendPayload<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, _ callback: @escaping FGApiResponseCallback<Value>) {
        self.resolver.resolveUrlWithVersion { response in
            
            // return error
            guard response.error == nil else {
                callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                return
            }
            
            // append api path to the url
            var mutablePayload = payload
            mutablePayload.url = response.value
            
            // send payload
            self.helper.send(mutablePayload) { (response: FGRequestHelperResponse<Value>) in
                
                // check for error
                guard response.error == nil else {
                    callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                    return
                }
                
                // return success
                callback(FGApiResponse.success(response.value!))
            }
        }
    }
    
}