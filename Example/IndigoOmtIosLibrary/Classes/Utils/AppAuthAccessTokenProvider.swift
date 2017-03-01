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

protocol AppAuthAccessTokenProviderDelegate: class {
    
    func didRefreshAccessToken(for provider: AppAuthAccessTokenProvider)
}

class AppAuthAccessTokenProvider: FGAccessTokenProvider {
    
    // MARK: - properties
    
    private let authState: OIDAuthState
    private let queue: DispatchQueue
    public weak var delegate: AppAuthAccessTokenProviderDelegate?
    
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
            
            // print error
            if let error = error {
                print("AppAuthAccessTokenProvider - requestNewAccessToken: \(error.localizedDescription)")
            }
            
            // call delegate
            if let delegate = self.delegate, success {
                delegate.didRefreshAccessToken(for: self)
            }
            
            // call in dispatch queue
            self.queue.async {
                callback(success)
            }
        })
    }
    
}
