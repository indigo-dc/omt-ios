//
//  FGEmptyObject.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Empty serialization object for HTTP status codes 204 and 205.
open class FGEmptyObject: FGObjectSerializable {
    
    public let emptyStatusCodes = [204, 205]
    
    public required init?(response: HTTPURLResponse, json: JSON) {
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
