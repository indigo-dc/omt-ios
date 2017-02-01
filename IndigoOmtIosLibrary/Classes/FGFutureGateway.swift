//
//  FGFutureGateway.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// Future Gateway entry object.
open class FGFutureGateway {
    
    // MARK: - properties
    
    /// Currently supported API version.
    public let apiVersion: String = "v1.0"
    
    /// Application collection API.
    public let applicationCollection: FGApplicationCollectionApi
    
    /// Infrastructure collection API.
    public let infrastructureCollection: FGInfrastructureCollectionApi
    
    /// Task collection API.
    public let taskCollection: FGTaskCollectionApi
    
    // MARK: - lifecycle
    
    public init(url: URL, provider: FGAccessTokenProvider) {
        
        // create background dispatch queue
        let queue = DispatchQueue(label: "pl.psnc.futuregateway-queue", attributes: .concurrent)
        
        // create session helpers
        let unauthSession = FGUnauthorizedSessionHelper(queue: queue)
        //let authSession = try FGAuthorizedSessionHelper(authState: authState)
        let authSession = unauthSession
        
        // create API resolver to get root url with version
        let apiResolver = FGApiResolver(url: url, versionID: self.apiVersion, helper: unauthSession)
        
        // create required APIs
        self.applicationCollection = FGApplicationCollectionApi(resolver: apiResolver, helper: authSession)
        self.infrastructureCollection = FGInfrastructureCollectionApi(resolver: apiResolver, helper: authSession)
        self.taskCollection = FGTaskCollectionApi(resolver: apiResolver, helper: authSession)
    }
    
}
