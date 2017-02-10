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
public struct FGRequestHelperResponse<Value>: CustomStringConvertible {
    
    // MARK: - properties
    
    /// The URL request sent to the server.
    public var request: URLRequest?
    
    /// The server's response to the URL request.
    public var response: HTTPURLResponse?
    
    /// The data returned by the server.
    public var data: Data?
    
    /// Nil when no problems occurred.
    public var error: FGFutureGatewayError?
    
    /// Requested object. nil when error occurred.
    public var value: Value?
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGRequestHelperResponse { error: \(error), value: \(value) }"
    }
    
    // MARK: - lifecycle
    
    public init(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: FGFutureGatewayError?, value: Value?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.value = value
    }
    
}

/// HTTP methods enumeration.
public enum FGHTTPMethod: String {
    case notset  = "notset"
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
    
    /// HTTP method of the payload.
    public var method: FGHTTPMethod
    
    /// Accepted respons encodings.
    public var accept: [String]
    
    /// HTTP request headers.
    public var headers: [String: String]
    
    /// URL parameters
    public var parameters: [String: Any]
    
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

/// Request helper class.
public protocol FGRequestHelper {
    
    /// Dispatch queue for background execution.
    func getBackgroundQueue() -> DispatchQueue
    
    /// Makes remote request and returns response in callback.
    func send<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping FGRequestHelperCallback<Value>)
    
}
