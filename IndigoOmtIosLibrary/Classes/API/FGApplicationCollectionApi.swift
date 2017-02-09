//
//  FGApplicationCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 24.01.2017.
//
//

import Foundation

/// API for Future Gateway Application Collection.
open class FGApplicationCollectionApi: FGAbstractCollectionApi {
    
    // MARK: - lifecycle
    
    public init(username: String, resolver: FGApiResolver, helper: FGRequestHelper) {
        super.init(apiPath: "applications", username: username, resolver: resolver, helper: helper)
    }
    
}
