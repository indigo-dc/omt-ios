//
//  FGBaseApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// Resolve API callback.
public typealias FGApiResolverCallback = (_ response: FGApiResolverResponse) -> ()

/// Resolves API URL with version.
open class FGApiResolver: FGAbstractApi {
    
    // MARK: - properties
    
    /// Base API URL.
    public let url: URL
    
    /// API version identifier.
    public let versionID: String
    
    /// Resolved API URL for given version.
    private var resolvedUrl: URL?
    
    // MARK: - lifecycle
    
    public init(url: URL, versionID: String, helper: FGSessionHelper) {
        self.url = url
        self.versionID = versionID
        super.init(helper: helper)
    }
    
    // MARK: - public methods
    
    /// Resolves API URL for given version.
    /// Returns error when requested version is not available.
    public func resolveUrlWithVersion(_ callback: @escaping FGApiResolverCallback) {
        
        // url was resolved earlier
        if let url = self.resolvedUrl {
            self.queue.async {
                callback(FGApiResolverResponse(url: url, error: nil))
            }
            return
        }
        
        // resolve url
        manager.request(self.url).validate().responseObject(queue: self.queue) { (response: DataResponse<FGApiRoot>) in
            
            // make sure there was no error
            guard response.error == nil else {
                callback(FGApiResolverResponse(url: nil, error: response.error as? FGFutureGatewayError))
                return
            }
            
            // find requested version
            if let apiRootObj: FGApiRoot = response.result.value {
                for versionObj: FGApiRootVersion in apiRootObj.versions {
                    
                    // version was found
                    if versionObj.id == self.versionID {
                        
                        // get first link
                        if let linkObj = versionObj.links.first {
                            
                            // save resolved URL
                            self.resolvedUrl = self.url.appendingPathComponent(linkObj.href)
                            
                            // return the URL
                            callback(FGApiResolverResponse(url: self.resolvedUrl, error: nil))
                            return
                        }
                    }
                }
            }
            
            // version was not found - raise error
            callback(FGApiResolverResponse(url: nil, error: FGFutureGatewayError.versionNotFound(reason: "Requested version \(self.versionID) was not found at \(self.url)")))
        }
    }
    
    /// Resolves API base URL without appended versions.
    public func resolveBaseUrl(_ callback: @escaping FGApiResolverCallback) {
        self.queue.async {
            callback(FGApiResolverResponse(url: self.url, error: nil))
        }
    }
    
}
