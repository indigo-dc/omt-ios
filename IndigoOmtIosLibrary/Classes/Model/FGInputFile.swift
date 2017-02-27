//
//  FGInputFile.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//
//

import Foundation
import SwiftyJSON

/// The current status of the input file.
public enum FGInputFileStatus: String {
    
    /// The input file has not been provided.
    case needed = "NEEDED"
    
    /// The input file has been provided.
    case ready = "READY"
}

/// Future Gateway input file object.
open class FGInputFile: FGObjectSerializable, FGDownloadableFile, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Name of the input file.
    public var name: String?
    
    /// Status of the input file.
    public var status: FGInputFileStatus?
    
    /// FGDownloadableFile.
    public var url: String?
    
    // CustomStringConvertible.
    public var description: String {
        return "FGInputFile { name: \(name), status: \(status) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string
        else {
            return nil
        }
        
        self.name = name
        if let status = FGInputFileStatus(rawValue: json["status"].stringValue) {
            self.status = status
        }
        if let url = json["url"].string {
            self.url = url
        }
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let name = self.name {
            json["name"].string = name
        }
        if let status = self.status {
            json["status"].string = status.rawValue
        }
        if let url = self.url {
            json["url"].string = url
        }
        
        return json
    }
    
}
