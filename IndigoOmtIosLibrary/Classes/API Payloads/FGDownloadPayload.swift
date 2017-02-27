//
//  FGDownloadPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.02.2017.
//
//

import Foundation

/// Download payload response callback.
public typealias FGDownloadPayloadResponseCallback = (FGApiResponse<FGEmptyObject>) -> ()

/// Download paybload class.
open class FGDownloadPayload: FGAbstractPayload {
    
    /// MARK: - properties
    
    /// Path to download file.
    public var destinationURL: URL?
    
    /// CustomStringConvertible.
    public override var description: String {
        return "FGRequestPayload { url: \(url), resourcePath: \(resourcePath), method: \(method) }"
    }
    
}
