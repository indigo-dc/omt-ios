//
//  FGRuntimeDataObject.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway runtime data object.
open class FGRuntimeDataObject: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Parameter name.
    public var name: String?
    
    /// Parameter value.
    public var value: String?
    
    /// Parameter description.
    public var dataDescription: String?
    
    /// Parameter creation date.
    public var creation: Date?
    
    /// Parameter last change date.
    public var lastChange: Date?
    
    public var description: String {
        return "FGRuntimeDataObject { name: \(name), value: \(value) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string,
            let value = json["value"].string
        else {
            return nil
        }
        
        self.name = name
        self.value = value
        self.dataDescription = json["description"].string
        self.creation = FGDateUtil.parseDate(json["creation"].string)
        self.lastChange = FGDateUtil.parseDate(json["last_change"].string)
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let name = name {
            json["name"].string = name
        }
        if let value = value {
            json["value"].string = value
        }
        if let dataDescription = dataDescription {
            json["description"].string = dataDescription
        }
        if let creation = creation {
            json["creation"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ss.SSSZ", date: creation)
        }
        if let lastChange = lastChange {
            json["last_change"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ss.SSSZ", date: lastChange)
        }
        
        return json
    }
    
}
