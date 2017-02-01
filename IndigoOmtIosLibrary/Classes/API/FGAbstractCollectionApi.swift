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
    
    /// API URL resolver
    public let resolver: FGApiResolver
    
    // MARK: - lifecycle
    
    public init(resolver: FGApiResolver, helper: FGSessionHelper) {
        self.resolver = resolver
        super.init(helper: helper)
    }
    
}
