//
//  FGTaskCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// API for Future Gateway Task Collection.
open class FGTaskCollectionApi: FGAbstractCollectionApi {
    
    // MARK: - lifecycle
    
    public init(username: String, resolver: FGApiResolver, helper: FGRequestHelper) {
        super.init(apiPath: "tasks", username: username, resolver: resolver, helper: helper)
    }
    
    
}