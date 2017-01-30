//
//  FGFutureGatewayError.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 25.01.2017.
//
//

import Foundation

/// All Future Gateway Errors enumeration.
public enum FGFutureGatewayError: Error, LocalizedError {
    
    /// Captures any underlying Error from the URLSession API.
    case network(error: Error)
    
    /// Remote response cannot be serialized to JSON.
    case jsonSerialization(error: Error)
    
    /// Remote JSON cannot be serialized to object instance.
    case objectSerialization(reason: String)
    
    /// API version was not found for given root URL.
    case versionNotFound(reason: String)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
            
        case .network(error: let error):
            return "Future Gateway network error: \(error.localizedDescription)"
            
        case .jsonSerialization(error: let error):
            return "Future Gateway JSON serialization error: \(error.localizedDescription)"
            
        case .objectSerialization(reason: let reason):
            return "Future Gateway object serialization error: \(reason)"
            
        case .versionNotFound(reason: let reason):
            return "Future Gateway version not found error: \(reason)"
            
        default:
            return "Future Gateway error"
        }
    }
    
}
