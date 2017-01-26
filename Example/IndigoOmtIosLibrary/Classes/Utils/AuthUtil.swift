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

/// Auth helper util for OAuth flow with AppAuth library.
class AuthUtil {
    
    // MARK: - properties
    
    /// Default instance of auth util.
    static private (set) var `default`: AuthUtil = AuthUtil(userDefaultsKey: "authConfigKey")
    
    /// AppAuth library authorization flow session.
    private var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private var config: AuthConfig?
    
    /// UserDefaults key where config is stored.
    private let userDefaultsKey: String
    
    /// API for retrieving user info from auth server.
    private var userInfoApi: UserInfoApi?
    
    /// True if config is not empty.
    public var hasConfig: Bool {
        return config != nil
    }
    
    // MARK: - lifecycle
    
    public init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }
    
    public func loadConfig() {
        if let data = UserDefaults.standard.data(forKey: "config") {
            self.config = NSKeyedUnarchiver.unarchiveObject(with: data) as? AuthConfig
        }
        
        if hasConfig {
            print("[AuthUtil] Found config")
        }
        else {
            print("[AuthUtil] Config was not found. User will have to authenticate in browser")
        }
    }
    
    public func clearConfig() {
        saveConfig(nil)
    }
    
    private func saveConfig(_ config: AuthConfig?) {
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
    
    public func beginAuthorizationFlow() {
        
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
            beginAuthorizationFlow(with: issuerUrl, redirectUri: redirectUri)
        }
    }
    
    public func resumeAuthorizationFlow(_ url: URL) {
        if let authFlow = self.currentAuthorizationFlow {
            if authFlow.resumeAuthorizationFlow(with: url) {
                self.currentAuthorizationFlow = nil
            }
        }
    }
    
    private func beginAuthorizationFlow(with issuerUrl: URL, redirectUri: URL) {
        
        // find OAuth endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerUrl) { configuration, error in
            
            guard error == nil else {
                
                // show error
                UIHelper.showError(error!.localizedDescription)
                
                return
            }
            
            // make request
            self.makeAuthorizationRequest(configuration!, redirectUri: redirectUri)
        }
    }
    
    private func makeAuthorizationRequest(_ serviceConfiguration: OIDServiceConfiguration, redirectUri: URL) {
        
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
                
                // show error
                UIHelper.showError(error!.localizedDescription)
                
                return
            }
            
            // fetch user info
            self.fetchUserInfo(authState!) { userInfo, error in
                
                guard error == nil else {
                    
                    // show error
                    UIHelper.showError(error!.localizedDescription)
                    
                    return
                }
                
                print("Found user: \(userInfo)")
                
                // clear previous config
                self.clearConfig()
                
                // prepare new config
                let config = AuthConfig()
                config.authState = authState
                config.userInfo = userInfo
                
                // save configuration
                self.saveConfig(config)
            }
        }
    }
    
    private func fetchUserInfo(_ authState: OIDAuthState, callback: @escaping UserInfoApiCallback) {
        do {
            // for background API activity
            let queue = DispatchQueue.global()
            
            // create authorized api
            let authSession = try FGAuthorizedSessionHelper(queue: queue, authState: authState)
            self.userInfoApi = UserInfoApi(helper: authSession)
            
            // get proper endpoint
            if let userInfoUrl = authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint {
                
                // get user info object
                self.userInfoApi?.fetchUserInfo(userInfoUrl) { userInfo, error in
                    callback(userInfo, error)
                }
            }
        }
        catch {
            UIHelper.showError("Error: \(error.localizedDescription)")
        }
    }
    
}
