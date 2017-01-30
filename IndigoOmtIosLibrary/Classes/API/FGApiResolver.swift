//
//  FGBaseApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// Resolve API response.
public struct FGApiResolverResponse: CustomStringConvertible {
    
    /// If false then result is from remote server response.
    public var isLocalResponse: Bool
    
    /// Resolved URL or nil when error occured.
    public var url: URL?
    
    /// Resolver error.
    public var error: FGFutureGatewayError?
    
    public var description: String {
        return "FGApiResolverResponse { isLocalResponse: \(isLocalResponse), url: \(url), error: \(error) }"
    }
    
    // MARK: - lifecycle
    
    public init(isLocalResponse: Bool, url: URL?, error: FGFutureGatewayError?) {
        self.isLocalResponse = isLocalResponse
        self.url = url
        self.error = error
    }
    
    public init() {
        self.init(isLocalResponse: false, url: nil, error: nil)
    }
    
}

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
    public func resolveApiUrl(_ callback: @escaping FGApiResolverCallback) {
        
        // url was resolved earlier
        if let url = self.resolvedUrl {
            self.queue.async {
                callback(FGApiResolverResponse(isLocalResponse: true, url: url, error: nil))
            }
            return
        }
        
        // resolve url
        manager.request(self.url).responseObject(queue: self.queue) { (response: DataResponse<FGApiRoot>) in
            
            // make sure there was no error
            guard response.error == nil else {
                callback(FGApiResolverResponse(isLocalResponse: false, url: nil, error: response.error as? FGFutureGatewayError))
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
                            callback(FGApiResolverResponse(isLocalResponse: false, url: self.resolvedUrl, error: nil))
                            return
                        }
                    }
                }
            }
            
            // version was not found - raise error
            callback(FGApiResolverResponse(isLocalResponse: false, url: nil, error: FGFutureGatewayError.versionNotFound(reason: "Requested version \(self.versionID) was not found at \(self.url)")))
        }
    }
    
}
