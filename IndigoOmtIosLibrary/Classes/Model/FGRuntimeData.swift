//
//  FGRuntimeData.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway runtime data object.
open class FGRuntimeData: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// .
    public var name: String = ""
    
    /// .
    public var value: String = ""
    
    /// .
    public var dataDescription: String = ""
    
    /// .
    public var creation: Date?
    
    /// .
    public var lastChange: Date?
    
    public var description: String {
        return "FGRuntimeData { name: \(name), value: \(value) }"
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
        
        if let dataDescription = json["description"].string {
            self.dataDescription = dataDescription
        }
        
        self.creation = FGDateUtil.parseDate(json["creation"].string)
        self.lastChange = FGDateUtil.parseDate(json["last_change"].string)
    }
    
}
