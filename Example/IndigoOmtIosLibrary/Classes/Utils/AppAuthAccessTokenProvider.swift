//
//  AppAuthAccessTokenProvider.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 27.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary
import AppAuth

class AppAuthAccessTokenProvider: FGAccessTokenProvider {
    
    // MARK: - properties
    
    private let authState: OIDAuthState
    private let queue: DispatchQueue
    
    // MARK: - lifecycle
    
    init(authState: OIDAuthState, queue: DispatchQueue) {
        self.authState = authState
        self.queue = queue
    }
    
    // MARK: - FGAccessTokenProvider
    
    func getAccessToken() -> String {
        var accessToken = "none"
        if let at = authState.lastTokenResponse?.accessToken {
            accessToken = at
        }
        if let at = authState.lastAuthorizationResponse.accessToken {
            accessToken = at
        }
        return accessToken
    }
    
    func requestNewAccessToken(_ callback: @escaping FGAccessTokenProviderCallback) {
        
        // refresh access token on remote server
        authState.setNeedsTokenRefresh()
        authState.performAction(freshTokens: { (_, _, error) in
            
            // success means no errors
            let success = (error == nil)
            
            // call in dispatch queue
            self.queue.async {
                callback(success)
            }
        })
    }
    
}
