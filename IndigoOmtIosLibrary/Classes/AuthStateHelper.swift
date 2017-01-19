//
//  AuthStateHelper.swift
//  Pods
//
//  Created by Sebastian Mamczak on 17.01.2017.
//
//

import Foundation
import AppAuth

public typealias AuthStateHelperGetAccessTokenCallback = (String?, Error?) -> ()

public class AuthStateHelper {
    
    /// Fetches access token from AuthState object. Callback is returned in background queue.
    public static func getAccessTokenInBackground(_ authState: OIDAuthState,
                               dispatchQueue: DispatchQueue = DispatchQueue.global(),
                               callback: @escaping AuthStateHelperGetAccessTokenCallback) {
        dispatchQueue.async {
            authState.performAction(freshTokens: { accessTokenObj, idTokenObj, errorObj in
                dispatchQueue.async {
                    callback(accessTokenObj, errorObj)
                }
            })
        }
    }
    
}
