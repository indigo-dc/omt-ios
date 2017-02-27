//
//  FGUploadPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.02.2017.
//
//

import Foundation

/// Upload payload callback.
public typealias FGUploadPayloadCallback = () -> ()

/// Upload payload class.
open class FGUploadPayload: FGAbstractPayload {
    
    /// MARK: - properties
    
    /// File to upload.
    public var sourceURL: URL?
    
    /// CustomStringConvertible.
    public override var description: String {
        return "FGUploadPayload { url: \(url), resourcePath: \(resourcePath), method: \(method) }"
    }
    
}
