//
//  FGAbstractSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 24.01.2017.
//
//

import Foundation
import Alamofire

/// Session helper protocol.
public protocol FGSessionHelper {
    
    /// Gets ready to use dispatch queue.
    func getDispatchQueue() -> DispatchQueue
    
    /// Gets ready to use session manager.
    func getSessionManager() -> SessionManager
}

/// Default implementation of FGSessionHelper.
open class FGAbstractSessionHelper: FGSessionHelper, RequestAdapter, RequestRetrier {
    
    // MARK: - properties
    
    private let queue: DispatchQueue
    
    // MARK: - lifecycle
    
    public init(queue: DispatchQueue) {
        self.queue = queue
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
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        // do not retry
        completion(false, 0.0)
    }
    
}
