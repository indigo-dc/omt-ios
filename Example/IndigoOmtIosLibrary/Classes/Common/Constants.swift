//
//  Constants.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Constants {

    /// Future gateway instance URL.
    static let FutureGatewayUrl: String = "YOUR_FUTURE_GATEWAY_URL"

    /// Open ID Connect Issuer from which the configuration will be discovered
    static let IssuerUrl: String = "YOUR_ISSUER_URL"

    /// OAuth client ID
    static let ClientID: String = "YOUR_CLIENT_ID"

    /// OAuth client secret - optional
    static let ClientSecret: String? = nil // "YOUR_CLIENT_SECRET"

    /// Redirect URI for the client. This scheme must be registered as a scheme in the project's Info
    /// property list ("CFBundleURLTypes" plist key). Any path component will work, we use
    /// 'oauthredirect' here to help disambiguate from any other use of this scheme.
    static let RedirectURI: String = "YOUR_SCHEME_FOR_REDIRECT://oauth2redirect"

    /// Open ID Scopes
    static let Scopes: [String] = ["openid", "profile", "offline_access"]

}
