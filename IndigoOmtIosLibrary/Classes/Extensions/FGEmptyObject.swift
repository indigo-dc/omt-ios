//
//  FGEmptyObject.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Empty serialization object.
open class FGEmptyObject: FGObjectSerializable {
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        let emptyStatusCodes = [204, 205]
        guard emptyStatusCodes.contains(response.statusCode) else {
            return nil
        }
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        return JSON("")
    }
    
}
