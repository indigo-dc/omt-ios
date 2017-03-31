//
//  FGRequestHelperResponse.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
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
    
    /// Response data as string.
    public var errorResponseBody: String? {
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGRequestHelperResponse { error: \(error as FGFutureGatewayError?), value: \(value as Value?) }"
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
