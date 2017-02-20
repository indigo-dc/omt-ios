//
//  FGParameter.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway parameter object.
open class FGParameter: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// Parameter name.
    public var name: String?
    
    /// Parameter value.
    public var value: String?
    
    /// Parameter description.
    public var parameterDescription: String?
    
    public var description: String {
        return "FGParameter { name: \(name), value: \(value) }"
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
        self.parameterDescription = json["description"].string
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let name = self.name {
            json["name"].string = name
        }
        if let value = self.value {
            json["value"].string = value
        }
        if let parameterDescription = self.parameterDescription {
            json["description"].string = parameterDescription
        }
        
        return json
    }
    
}
