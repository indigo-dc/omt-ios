//
//  FGAuthorizedSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire
import AppAuth

/// Authorized implementation of FGAbstractSessionHelper.
open class FGAuthorizedSessionHelper: FGAbstractSessionHelper {
    
    // MARK: - properties
    
    /// Auth state from AppAuth library.
    public let authState: OIDAuthState
    
    // MARK: - lifecycle
    
    public init(queue: DispatchQueue, authState: OIDAuthState) throws {
        if authState.isAuthorized == false {
            throw FGFutureGatewayError.unauthorizedState(reason: "authState is not authorized")
        }
        self.authState = authState
        super.init(queue: queue)
    }
    
    // MARK: - FGRequestHandler
    
    public override func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var mutableUrlRequest = urlRequest
        
        // turn off cache
        mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        // add authorization token
        mutableUrlRequest.setValue("Bearer \(extractAccessToken(authState))", forHTTPHeaderField: "Authorization")
        
        return mutableUrlRequest
    }
    
    public override func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(false, 0.0)
    }
    
    /// Extracts token from authState object.
    private func extractAccessToken(_ authState: OIDAuthState) -> String {
        var accessToken = "none"
        if let at = authState.lastTokenResponse?.accessToken {
            accessToken = at
        }
        if let at = authState.lastAuthorizationResponse.accessToken {
            accessToken = at
        }
        return accessToken
    }
    
}
