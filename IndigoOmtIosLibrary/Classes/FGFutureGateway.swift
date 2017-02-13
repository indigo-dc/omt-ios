//
//  FGFutureGateway.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// Future Gateway entry object.
open class FGFutureGateway: CustomStringConvertible {
    
    // MARK: - properties
    
    /// Currently supported API version.
    public let apiVersion: String = "v1.0"
    
    /// Application collection API.
    public let applicationCollection: FGApplicationCollectionApi
    
    /// Infrastructure collection API.
    public let infrastructureCollection: FGInfrastructureCollectionApi
    
    /// Task collection API.
    public let taskCollection: FGTaskCollectionApi
    
    /// CustomStringConvertible
    public var description: String {
        return "FGFutureGateway { apiVersion: \(apiVersion) }"
    }
    
    // MARK: - lifecycle
    
    public init(url: URL, username: String, provider: FGAccessTokenProvider) {
        
        // create background dispatch queue
        let queue = DispatchQueue(label: "pl.psnc.futuregateway-queue", attributes: .concurrent)
        
        // create session helpers for authorized and unauthorized access to API
        let unauthSession = FGSessionHelper(queue: queue, provider: nil)
        let authSession   = FGSessionHelper(queue: queue, provider: provider)
        
        // create request helpers - one for each session helper
        let unauthHelper = FGAlamofireRequestHelper(session: unauthSession)
        let authHelper   = FGAlamofireRequestHelper(session: authSession)
        
        // create API resolver to get root url with version
        let apiResolver = FGApiResolver(baseUrl: url, versionID: self.apiVersion, helper: unauthHelper)
        
        // create required APIs
        self.applicationCollection    = FGApplicationCollectionApi(username: username, resolver: apiResolver, helper: authHelper)
        self.infrastructureCollection = FGInfrastructureCollectionApi(username: username, resolver: apiResolver, helper: authHelper)
        self.taskCollection           = FGTaskCollectionApi(username: username, resolver: apiResolver, helper: authHelper)
    }
    
}