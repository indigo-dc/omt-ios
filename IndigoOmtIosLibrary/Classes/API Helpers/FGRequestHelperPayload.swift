//
//  FGRequestHelperPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//
//

import Foundation

/// HTTP methods enumeration.
public enum FGHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// The payload of FGRequestHelper request method.
public struct FGRequestHelperPayload: CustomStringConvertible {
    
    // MARK: - properties
    
    /// The URL of the payload.
    public var url: URL?
    
    /// This path will be appended to the resolved URL.
    public var resourcePath: String?
    
    /// HTTP method of the payload.
    public var method: FGHTTPMethod
    
    /// Accepted response encodings.
    public var accept: [String]
    
    /// HTTP request headers.
    public var headers: [String: String]
    
    /// URL parameters.
    public var parameters: [String: Any]
    
    /// Body of the payload.
    public var body: FGObjectSerializable?
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGRequestHelperPayload { url: \(url), method: \(method) }"
    }
    
    // MARK: - lifecycle
    
    /// The constructor.
    public init(url: URL? = nil, method: FGHTTPMethod) {
        self.url = url
        self.method = method
        self.parameters = [:]
        self.headers = [:]
        self.accept = []
    }
    
    /// MARK: - public methods
    
    public mutating func addParam(_ key: String, value: Any) {
        parameters[key] = value
    }
    
    public mutating func addHeader(_ key: String, value: String) {
        headers[key] = value
    }
    
    public mutating func addAccept(_ contentType: String) {
        accept.append(contentType)
    }
    
}
