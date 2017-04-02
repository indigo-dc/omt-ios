//
//  Constants.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class Constants {

    static let tempUsername: String = "futuregateway"

    /// Future gateway instance URL.
    static let FutureGatewayUrl: String = "http://62.3.168.167/"

    /// Open ID Connect Issuer from which the configuration will be discovered
    static let IssuerUrl: String = "https://iam-test.indigo-datacloud.eu"

    /// OAuth client ID
    static let ClientID: String = "6158f403-b6a0-4b17-b181-0543da55c7ef"

    /// OAuth client secret - optional
    static let ClientSecret: String? = nil // "YOUR_CLIENT_SECRET"

    /// Redirect URI for the client. This scheme must be registered as a scheme in the project's Info
    /// property list ("CFBundleURLTypes" plist key). Any path component will work, we use
    /// 'oauthredirect' here to help disambiguate from any other use of this scheme.
    static let RedirectURI: String = "pl.psnc.indigo.omt.sampleapp://oauth2redirect"

    /// Open ID Scopes
    static let Scopes: [String] = ["openid", "profile", "offline_access"]

}
