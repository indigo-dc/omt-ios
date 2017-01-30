//
//  FGAuthorizedSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// Authorized implementation of FGAbstractSessionHelper.
open class FGAuthorizedSessionHelper: FGAbstractSessionHelper {
    
    // MARK: - properties
    
    /// Access token provider.
    public let provider: FGAccessTokenProvider
    
    // MARK: - lifecycle
    
    public init(queue: DispatchQueue, provider: FGAccessTokenProvider) {
        self.provider = provider
        super.init(queue: queue)
    }
    
    // MARK: - FGRequestHandler
    
    public override func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var mutableUrlRequest = urlRequest
        
        // turn off cache
        mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        // add authorization token
        mutableUrlRequest.setValue("Bearer \(self.provider.getAccessToken())", forHTTPHeaderField: "Authorization")
        
        return mutableUrlRequest
    }
    
    public override func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        // max number of retries
        let maxRetryCount: UInt = 3
        
        guard
            request.retryCount < maxRetryCount,
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            completion(false, 0.0)
            return
        }
        
        // try to get a new access token
        provider.requestNewAccessToken { success in
            completion(success, 0.0)
        }
    }
    
}
