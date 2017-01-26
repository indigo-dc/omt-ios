//
//  FGFutureGatewayError.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 25.01.2017.
//
//

import Foundation

/// All Future Gateway Errors enumeration.
public enum FGFutureGatewayError: Error {
    
    /// Captures any underlying Error from the URLSession API.
    case network(error: Error)
    
    /// Remote response cannot be serialized to JSON.
    case jsonSerialization(error: Error)
    
    /// Remote JSON cannot be serialized to object instance.
    case objectSerialization(reason: String)
    
    /// Auth state object is not authorized.
    case unauthorizedState(error: String)
    
    /// API version was not found for given root URL.
    case versionNotFound(error: String)
    
}
