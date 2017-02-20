//
//  FGOutputFile.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway output file object.
open class FGOutputFile: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Name of the output file.
    public var name: String?
    
    /// Download link to the output file.
    public var url: String?
    
    public var description: String {
        return "FGOutputApiLink { name: \(name), url: \(url) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string,
            let url = json["url"].string
        else {
            return nil
        }
        
        self.name = name
        self.url = url
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let name = self.name {
            json["name"].string = name
        }
        if let url = self.url {
            json["url"].string = url
        }
        
        return json
    }
    
}
