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
    
    /// API URL resolver.
    public let resolver: FGApiResolver
    
    /// Authorized username for API requests
    public let username: String
    
    // MARK: - lifecycle
    
    public init(username: String, resolver: FGApiResolver, helper: FGSessionHelper) {
        self.username = username
        self.resolver = resolver
        super.init(helper: helper)
    }
    
}
