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
open class FGOutputFile: FGObjectSerializable, FGDownloadableFile, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Name of the output file.
    public var name: String?
    
    /// FGDownloadableFile.
    public var url: String?
    
    // CustomStringConvertible.
    public var description: String {
        return "FGOutputFile { name: \(name as String?), url: \(url as String?) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string
        else {
            return nil
        }
        
        self.name = name
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
        if let url = self.url {
            json["url"].string = url
        }
        
        return json
    }
    
}
