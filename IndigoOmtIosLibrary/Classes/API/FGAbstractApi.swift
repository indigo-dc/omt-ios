//
//  FGAbstractApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation

/// API response object.
public struct FGApiResponse<Value>: CustomStringConvertible {
    
    // MARK: - properties
    
    /// The error from the response.
    public var error: FGFutureGatewayError?
    
    /// The value from the response.
    public var value: Value?
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGApiResponse { error: \(error), value: \(value) }"
    }
    
    // MARK: - lifecycle
    
    public init(error: FGFutureGatewayError?, value: Value?) {
        self.error = error
        self.value = value
    }
    
}

/// API response callback.
public typealias FGApiResponseCallback<Value> = (FGApiResponse<Value>) -> ()

/// Abstract class for any API implementation.
open class FGAbstractApi {
    
    // MARK: - properties
    
    /// Request helper.
    public let helper: FGRequestHelper
    
    // MARK: - lifecycle
    
    public init(helper: FGRequestHelper) {
        self.helper = helper
    }
    
}
