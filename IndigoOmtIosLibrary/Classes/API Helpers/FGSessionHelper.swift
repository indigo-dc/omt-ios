//
//  FGSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 24.01.2017.
//
//

import Foundation
import Alamofire

/// Session helper class for Alamofire's SessionsManager.
open class FGSessionHelper: RequestAdapter, RequestRetrier {
    
    // MARK: - properties
    
    /// Background queue.
    private let queue: DispatchQueue
    
    /// Access token provider.
    public let provider: FGAccessTokenProvider?
    
    // MARK: - lifecycle
    
    public init(queue: DispatchQueue, provider: FGAccessTokenProvider?) {
        self.queue = queue
        self.provider = provider
    }
    
    // MARK: - FGSessionHelper
    
    public func getDispatchQueue() -> DispatchQueue {
        return queue
    }
    
    public func getSessionManager() -> SessionManager {
        let sessionManager = SessionManager()
        sessionManager.adapter = self
        sessionManager.retrier = self
        return sessionManager
    }
    
    // MARK: - RequestAdapter
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let provider = self.provider {
            var mutableUrlRequest = urlRequest
            
            // turn off cache
            mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            
            // add authorization token
            mutableUrlRequest.setValue("Bearer \(provider.getAccessToken())", forHTTPHeaderField: "Authorization")
            
            return mutableUrlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let provider = self.provider {
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
        else {
            // do not retry
            completion(false, 0.0)
        }
    }
    
}
