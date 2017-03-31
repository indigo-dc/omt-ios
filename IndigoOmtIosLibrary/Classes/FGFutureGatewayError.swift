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

    /// Request URL was nil.
    case urlIsEmpty(reason: String)

    /// Download destination or upload source are empty.
    case fileURLIsEmpty(reason: String)

    /// Upload filename is empty.
    case uploadFilenameIsEmpty(reason: String)

    /// File encoding error.
    case fileEncodingError(error: Error)

    /// File download error.
    case downloadFileError(error: Error)

    /// File upload error.
    case uploadFileError(error: Error)

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

        case .urlIsEmpty(reason: let reason):
            return "Future Gateway url is empty error: \(reason)"

        case .fileURLIsEmpty(reason: let reason):
            return "Future Gateway file URL is empty error: \(reason)"

        case .uploadFilenameIsEmpty(reason: let reason):
            return "Future Gateway upload filename is empty error: \(reason)"

        case .fileEncodingError(error: let error):
            return "Future Gateway file encoding error: \(error.localizedDescription)"

        case .downloadFileError(error: let error):
            return "Future Gateway download file error: \(error.localizedDescription)"

        case .uploadFileError(error: let error):
            return "Future Gateway upload file error: \(error.localizedDescription)"
        }
    }

}
