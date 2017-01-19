//
//  OIDCHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import AppAuth
import SwiftyJSON
import IndigoOmtIosLibrary

fileprivate typealias OIDCHelperFetchUserInfoCallback = (JSON?, Error?) -> ()

class OIDCHelper {
    
    // properties
    private var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private (set) var config: OIDCHelperConfig?
    var hasConfig: Bool {
        return config != nil
    }
    
    // static properties
    static private (set) var `default`: OIDCHelper = OIDCHelper()
    
    // MARK: - lifecycle
    
    private init() {
        // empty
    }
    
    public func loadConfig() {
        if let data = UserDefaults.standard.data(forKey: "config") {
            self.config = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDCHelperConfig
        }
        
        if hasConfig {
            print("[OIDCHelper] Found config")
        }
        else {
            print("[OIDCHelper] Config was not found. User will have to authenticate in browser")
        }
    }
    
    public func clearConfig() {
        self.currentAuthorizationFlow = nil
        saveConfig(nil)
    }
    
    private func saveConfig(_ configObj: OIDCHelperConfig?) {
        var data: Data? = nil
        if let config = configObj {
            data = NSKeyedArchiver.archivedData(withRootObject: config)
        }
        UserDefaults.standard.set(data, forKey: "config")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - authorization flow
    
    func beginAuthorizationFlow() {
        
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
    
    func resumeAuthorizationFlow(_ url: URL) {
        if let authFlow = self.currentAuthorizationFlow {
            if authFlow.resumeAuthorizationFlow(with: url) {
                self.currentAuthorizationFlow = nil
            }
        }
    }
    
    private func beginAuthorizationFlow(with issuerUrl: URL, redirectUri: URL) {
        
        // find OAuth endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerUrl) { configurationObj, error in
            
            // got configuration
            if let configuration = configurationObj {
                self.makeAuthorizationRequest(configuration, redirectUri: redirectUri)
            }
            else {
                
                // show error
                UIHelper.showError(error?.localizedDescription)
            }
        }
    }
    
    private func makeAuthorizationRequest(_ configuration: OIDServiceConfiguration, redirectUri: URL) {
        
        // prepare request object
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: Constants.ClientID,
                                              clientSecret: Constants.ClientSecret,
                                              scopes: Constants.Scopes,
                                              redirectURL: redirectUri,
                                              responseType: "code",
                                              additionalParameters: nil)
        
        // open browser for login purpose
        let rootViewController = UIHelper.getRootViewController()
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: rootViewController) { authStateObj, error in
            
            // get authorization
            if let authState = authStateObj {
                
                // clear previous config
                self.clearConfig()
                
                // prepare new config
                let helperConfig = OIDCHelperConfig()
                helperConfig.authState = authState
                
                // fetch user info
                self.fetchUserInfo(authState) { userInfoJsonObj, errorObj in
                    
                    if let error = errorObj {
                        
                        // show error
                        UIHelper.showError(error.localizedDescription)
                        
                        return
                    }
                    
                    if let userInfoJson = userInfoJsonObj {
                        
                        // extract username
                        helperConfig.userName = userInfoJson["preferred_username"].string
                        
                        // save configuration
                        self.saveConfig(helperConfig)
                    }
                }
            }
            else {
                
                // show error
                UIHelper.showError(error?.localizedDescription)
            }
        }
    }
    
    private func fetchUserInfo(_ authState: OIDAuthState, callback: @escaping OIDCHelperFetchUserInfoCallback) {
        
        // get proper endpoint
        let userInfoUrlObj = authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint
        
        // get user info in background
        let bgQueue = DispatchQueue.global()
        
        // get fresh access token
        AuthStateHelper.getAccessTokenInBackground(authState, dispatchQueue: bgQueue) { accessTokenObj, errorObj in
            
            if let error = errorObj {
                
                // return error
                callback(nil, error)
                return
            }
            
            // make HTTP request to get user info json object
            if let userInfoUrl = userInfoUrlObj, let accessToken = accessTokenObj {
                
                self.makeHttpRequest(userInfoUrl, accessToken: accessToken, callback: callback)
            }
        }
    }
    
    private func makeHttpRequest(_ url: URL, accessToken: String, callback: @escaping OIDCHelperFetchUserInfoCallback) {
        
        // prepare request
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // prepare session and task
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let postTask = session.dataTask(with: request) { dataObj, responseObj, errorObj in
            
            if let error = errorObj {
                
                // return error
                callback(nil, error)
                
                return
            }
            
            if let data = dataObj {
                let json = JSON(data: data)
                callback(json, nil)
            }
        }
        postTask.resume()
    }
    
}

class OIDCHelperConfig: NSObject, NSCoding {
    
    // MARK: - properties
    
    var authState: OIDAuthState?
    var userName: String?
    
    // MARK: - lifecycle
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.authState = aDecoder.decodeObject(forKey: "authState") as? OIDAuthState
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.authState, forKey: "authState")
        aCoder.encode(self.userName, forKey: "userName")
    }
    
}
