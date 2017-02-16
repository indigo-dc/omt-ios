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
open class FGInputFile: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Name of the input file.
    public var name: String?
    
    /// Status of the input file.
    public var status: FGInputFileStatus?
    
    public var description: String {
        return "FGInputFile { name: \(name), status: \(status) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string,
            let status = FGInputFileStatus(rawValue: json["status"].stringValue)
        else {
            return nil
        }
        
        self.name = name
        self.status = status
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let name = name {
            json["name"].string = name
        }
        if let status = status {
            json["status"].string = status.rawValue
        }
        
        return json
    }
    
}