//
//  FGAccessTokenProvider.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 27.01.2017.
//
//

import Foundation

/// FGAccessTokenProvider callback.
public typealias FGAccessTokenProviderCallback = (_ success: Bool) -> Void

/// Helps getting access from authorization object and fetching new token when current one is invalid.
public protocol FGAccessTokenProvider {

    /// Gets access token from current authorization object.
    func getAccessToken() -> String

    /// Send request for new access token.
    func requestNewAccessToken(_ callback: @escaping FGAccessTokenProviderCallback)

}
