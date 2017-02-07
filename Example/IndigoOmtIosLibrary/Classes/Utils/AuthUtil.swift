//
//  AuthUtil.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AppAuth
import SwiftyJSON
import IndigoOmtIosLibrary

/// Auth util callback.
typealias AuthUtilAuthorizationCallback = (_ provider: FGAccessTokenProvider?, _ error: Error?) -> ()

/// Auth helper util for OAuth flow with AppAuth library.
class AuthUtil {
    
    // MARK: - properties
    
    /// Default instance of auth util.
    static let `default`: AuthUtil = AuthUtil(userDefaultsKey: "authConfigKey")
    
    /// AppAuth library authorization flow session.
    private var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    
    /// Holds authorization object and user info.
    private var config: AuthConfig?
    
    /// UserDefaults key where config is stored.
    private let userDefaultsKey: String
    
    /// API for retrieving user info from auth server.
    private var userInfoApi: UserInfoApi?
    
    /// Background queue.
    private let queue = DispatchQueue.global()
    
    /// True if config is not empty.
    public var isAuthorized: Bool {
        return config != nil
    }
    
    // MARK: - lifecycle
    
    public init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    public func loadState() {
        if let data = UserDefaults.standard.data(forKey: "config") {
            self.config = NSKeyedUnarchiver.unarchiveObject(with: data) as? AuthConfig
        }
        
        if self.isAuthorized {
            print("[AuthUtil] Found config")
        }
        else {
            print("[AuthUtil] Config was not found. User will have to authenticate in browser")
        }
    }
    
    public func clearState() {
        self.saveState(nil)
    }
    
    private func saveState(_ config: AuthConfig?) {
        // update object
        self.config = config
        
        var data: Data? = nil
        if let config = config {
            // data will be stored in UserDefaults
            data = NSKeyedArchiver.archivedData(withRootObject: config)
        }
        
        // update UserDefaults
        UserDefaults.standard.set(data, forKey: "config")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - authorization flow
    
    public func beginAuthorizationFlow(callback: @escaping AuthUtilAuthorizationCallback) {
        
        // check urls
        let issuerUrlOptional: URL? = URL(string: Constants.IssuerUrl)
        guard issuerUrlOptional != nil else {
            fatalError("Issuer URL cannot be empty")
        }
        
        let redirectUriOptional: URL? = URL(string: Constants.RedirectURI)
        guard redirectUriOptional != nil else {
            fatalError("Redirect URI cannot be empty")
        }
        
        // process
        if let issuerUrl = issuerUrlOptional, let redirectUri = redirectUriOptional {
            beginAuthorizationFlow(with: issuerUrl, redirectUri: redirectUri, callback: callback)
        }
    }
    
    public func resumeAuthorizationFlow(_ url: URL) {
        if let authFlow = self.currentAuthorizationFlow {
            if authFlow.resumeAuthorizationFlow(with: url) {
                self.currentAuthorizationFlow = nil
            }
        }
    }
    
    private func beginAuthorizationFlow(with issuerUrl: URL, redirectUri: URL, callback: @escaping AuthUtilAuthorizationCallback) {
        
        // find OAuth endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerUrl) { configuration, error in
            
            guard error == nil else {
                
                // return error in main thread
                DispatchQueue.main.async {
                    callback(nil, error)
                }
                
                return
            }
            
            // make request
            self.makeAuthorizationRequest(configuration!, redirectUri: redirectUri, callback: callback)
        }
    }
    
    private func makeAuthorizationRequest(_ serviceConfiguration: OIDServiceConfiguration, redirectUri: URL, callback: @escaping AuthUtilAuthorizationCallback) {
        
        // prepare request object
        let request = OIDAuthorizationRequest(configuration: serviceConfiguration,
                                              clientId: Constants.ClientID,
                                              clientSecret: Constants.ClientSecret,
                                              scopes: Constants.Scopes,
                                              redirectURL: redirectUri,
                                              responseType: "code",
                                              additionalParameters: nil)
        
        // open browser for login purpose
        let rootViewController = UIHelper.getRootViewController()
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: rootViewController) { authState, error in
            
            guard error == nil else {
                
                // return error in main thread
                DispatchQueue.main.async {
                    callback(nil, error)
                }
                
                return
            }
            
            // clear previous config
            self.clearState()
            
            // prepare new config
            let config = AuthConfig()
            config.authState = authState
            
            // save configuration
            self.saveState(config)
            
            // return provider in main thread
            DispatchQueue.main.async {
                if let provider = self.getAccessTokenProvider() {
                    callback(provider, nil)
                }
            }
        }
    }
    
    // MARK: - utils
    
    public func getAccessTokenProvider() -> FGAccessTokenProvider? {
        guard
            let authState = self.config?.authState,
            authState.isAuthorized
        else {
            return nil
        }
        
        return AppAuthAccessTokenProvider(authState: authState, queue: self.queue)
    }
    
    public func getUserInfo() -> UserInfo? {
        return self.config?.userInfo
    }
    
    public func fetchUserInfo(_ callback: @escaping UserInfoApiCallback) {
        
        // check if user info already exists
        if let userInfo = getUserInfo() {
            
            // in main thread
            DispatchQueue.main.async {
                callback(userInfo, nil)
            }
            
            return
        }
        
        guard
            let provider = self.getAccessTokenProvider(),
            let userInfoUrl = self.config?.authState?.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint
        else {
            
            // in main thread
            DispatchQueue.main.async {
                callback(nil, UserInfoApiError.notAuthorized(reason: "AuthUtil is not authorized"))
            }
            
            return
        }
        
        // for background API activity
        let queue = DispatchQueue.global()
        
        // create authorized api
        let authSession = FGSessionHelper(queue: queue, provider: provider)
        self.userInfoApi = UserInfoApi(helper: authSession)
        
        // get user info object
        self.userInfoApi?.fetchUserInfo(userInfoUrl) { userInfo, error in
            
            guard error == nil else {
                
                // return error in main thread
                DispatchQueue.main.async {
                    callback(nil, error)
                }
                
                return
            }
            
            // update configuration
            self.config?.userInfo = userInfo
            self.saveState(self.config)
            
            // in main thread
            DispatchQueue.main.async {
                callback(userInfo, nil)
            }
        }
    }
    
}
