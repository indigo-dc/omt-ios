//
//  FGRuntimeDataParameter.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway runtime data object.
open class FGRuntimeDataParameter: FGParameter {
    
    // MARK: - properties
    
    
    /// Parameter creation date.
    public var creation: Date?
    
    /// Parameter last change date.
    public var lastChange: Date?
    
    public override var description: String {
        return "FGRuntimeDataParameter { name: \(name), value: \(value) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        super.init(response: response, json: json)
        
        self.creation = FGDateUtil.parseDate(json["creation"].string)
        self.lastChange = FGDateUtil.parseDate(json["last_change"].string)
    }
    
    public override init() {
        super.init()
    }
    
    public override func serialize() -> JSON {
        var json = super.serialize()
        
        if let creation = self.creation {
            json["creation"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ss.SSSZ", date: creation)
        }
        if let lastChange = self.lastChange {
            json["last_change"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ss.SSSZ", date: lastChange)
        }
        
        return json
    }
    
}
