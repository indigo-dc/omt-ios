//
//  FGApiResolverResponse.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 02.02.2017.
//
//

import Foundation

/// Resolve API response.
public struct FGApiResolverResponse: CustomStringConvertible {
    
    /// Resolved URL or nil when error occured.
    public var url: URL?
    
    /// Resolver error.
    public var error: FGFutureGatewayError?
    
    public var description: String {
        return "FGApiResolverResponse { url: \(url), error: \(error) }"
    }
    
    // MARK: - lifecycle
    
    public init(url: URL?, error: FGFutureGatewayError?) {
        self.url = url
        self.error = error
    }
    
    public init() {
        self.init(url: nil, error: nil)
    }
    
}
