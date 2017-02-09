//
//  FGAbstractCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// Abstract collection API class.
open class FGAbstractCollectionApi: FGAbstractApi {
    
    // MARK: - properties
    
    /// API URL path.
    public let apiPath: String
    
    /// Authorized username for API requests
    public let username: String
    
    /// API URL resolver.
    public let resolver: FGApiResolver
    
    // MARK: - lifecycle
    
    public init(apiPath: String, username: String, resolver: FGApiResolver, helper: FGRequestHelper) {
        self.apiPath = apiPath
        self.username = username
        self.resolver = resolver
        super.init(helper: helper)
    }
    
}
