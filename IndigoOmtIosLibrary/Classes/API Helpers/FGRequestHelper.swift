//
//  FGRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation

/// The callback of FGRequestHelper request method.
public typealias FGRequestHelperCallback<Value> = (FGRequestHelperResponse<Value>) -> ()

/// The response of FGRequestHelper request method.
public struct FGRequestHelperResponse<Value> {
    
    /// The URL request sent to the server.
    public let request: URLRequest?
    
    /// The server's response to the URL request.
    public let response: HTTPURLResponse?
    
    /// The data returned by the server.
    public let data: Data?
    
    /// Nil when no problems occurred.
    public let error: Error?
    
    /// Requested object. nil when error occurred.
    public let value: Value?
    
}

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
public struct FGRequestHelperPayload {
    
    // MARK: - properties
    
    /// The URL of the payload.
    public let url: URL
    
    /// HTTP method of the payload.
    public let method: FGHTTPMethod
    
    /// Accepted respons encodings.
    public private (set) var accept: [String]
    
    /// HTTP request headers.
    public private (set) var headers: [String: String]
    
    /// URL parameters
    public private (set) var parameters: [String: Any]
    
    // MARK: - lifecycle
    
    /// The constructor.
    public init(url: URL, method: FGHTTPMethod) {
        self.url = url
        self.method = method
        self.parameters = [:]
        self.headers = [:]
        self.accept = []
    }
    
    /// MARK: - public methods
    
    public mutating func addParam(key: String, value: Any) {
        parameters[key] = value
    }
    
    public mutating func addHeader(key: String, value: String) {
        headers[key] = value
    }
    
    public mutating func addAccept(_ contentType: String) {
        accept.append(contentType)
    }
    
}

/// Request helper class.
public protocol FGRequestHelper {
    
    /// Dispatch queue for background execution.
    func getBackgroundQueue() -> DispatchQueue
    
    /// Makes remote request and returns response in callback.
    func send<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping FGRequestHelperCallback<Value>)
    
}
