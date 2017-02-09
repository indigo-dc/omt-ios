//
//  FGInfrastructureCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// API for Future Gateway Infrastructure Collection.
open class FGInfrastructureCollectionApi: FGAbstractCollectionApi {
    
    // MARK: - lifecycle
    
    public init(username: String, resolver: FGApiResolver, helper: FGRequestHelper) {
        super.init(apiPath: "infrastructures", username: username, resolver: resolver, helper: helper)
    }
    
}
