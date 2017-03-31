//
//  FGApiResponse.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//
//

import Foundation

/// API response callback.
public typealias FGApiResponseCallback<Value> = (FGApiResponse<Value>) -> ()

/// API response object.
public enum FGApiResponse<Value>: CustomStringConvertible {
    
    /// Response was successful.
    case success(Value)
    
    /// Response has an error.
    case failure(FGFutureGatewayError, String?)
    
    // MARK: - properties
    
    /// The error from the response.
    public var error: FGFutureGatewayError? {
        switch self {
        case .failure(let error, _):
            return error
        default:
            return nil
        }
    }
    
    /// Sometimes when error occurs there is an error message in response body.
    public var errorResponseBody: String?  {
        switch self {
        case .failure(_, let errorResponseBody):
            return errorResponseBody
        default:
            return nil
        }
    }
    
    /// The value from the response.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    /// CustomStringConvertible.
    public var description: String {
        switch self {
        case .failure(let error, let errorResponseBody):
            return "FGApiResponse { error: \(error.localizedDescription as String?), errorResponseBody: \(errorResponseBody as String?) }"
        case .success(let value):
            return "FGApiResponse { \(value) }"
        }
    }
    
}
