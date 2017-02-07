//
//  FGBaseApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// The callback of FGApiResolver.
public typealias FGApiResolverCallback = (_ response: FGApiResolverResponse) -> ()

/// The response of FGApiResolver.
public struct FGApiResolverResponse: CustomStringConvertible {
    
    /// Resolved URL or nil when error occured.
    public var url: URL?
    
    /// Resolver error.
    public var error: FGFutureGatewayError?
    
    public var description: String {
        return "FGApiResolverResponse { url: \(url), error: \(error) }"
    }
    
}

/// Resolves API URL with version.
open class FGApiResolver: FGAbstractApi {
    
    // MARK: - properties
    
    /// Base API URL.
    public let baseUrl: URL
    
    /// API version identifier.
    public let versionID: String
    
    /// Resolved API URL with version.
    private var resolvedUrl: URL?
    
    // MARK: - lifecycle
    
    public init(baseUrl: URL, versionID: String, helper: FGRequestHelper) {
        self.baseUrl = baseUrl
        self.versionID = versionID
        super.init(helper: helper)
    }
    
    // MARK: - public methods
    
    /// Resolves API URL for given version.
    /// Returns error when requested version is not available.
    public func resolveUrlWithVersion(_ callback: @escaping FGApiResolverCallback) {
        
        // url was resolved earlier
        if let url = self.resolvedUrl {
            self.inBackground {
                callback(FGApiResolverResponse(url: url, error: nil))
            }
            return
        }
        
        // prepare payload
        let payload = FGRequestHelperPayload(url: self.baseUrl, method: .get)
        
        // resolve url
        self.helper.send(payload) { (response: FGRequestHelperResponse<FGApiRoot>) in
            
            // make sure there was no error
            guard response.error == nil else {
                callback(FGApiResolverResponse(url: nil, error: response.error as? FGFutureGatewayError))
                return
            }
            
            // find requested version
            if let apiRootObj: FGApiRoot = response.value {
                for versionObj: FGApiRootVersion in apiRootObj.versions {
                    
                    // version was found
                    if versionObj.id == self.versionID {
                        
                        // get first link
                        if let linkObj = versionObj.links.first {
                            
                            // save resolved URL
                            self.resolvedUrl = self.baseUrl.appendingPathComponent(linkObj.href)
                            
                            // return the URL
                            callback(FGApiResolverResponse(url: self.resolvedUrl, error: nil))
                            return
                        }
                    }
                }
            }
            
            // version was not found - raise error
            callback(FGApiResolverResponse(url: nil, error: FGFutureGatewayError.versionNotFound(reason: "Requested version \(self.versionID) was not found at \(self.baseUrl)")))
        }
        
        /*
        // resolve url
        manager.request(self.baseUrl).validate().responseObject(queue: self.helper.getBackgroundQueue()) { (response: DataResponse<FGApiRoot>) in
            
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
                            self.resolvedUrl = self.baseUrl.appendingPathComponent(linkObj.href)
                            
                            // return the URL
                            callback(FGApiResolverResponse(url: self.resolvedUrl, error: nil))
                            return
                        }
                    }
                }
            }
            
            // version was not found - raise error
            callback(FGApiResolverResponse(url: nil, error: FGFutureGatewayError.versionNotFound(reason: "Requested version \(self.versionID) was not found at \(self.baseUrl)")))
        }*/
    }
    
}
