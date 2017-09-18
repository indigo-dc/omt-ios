//
//  FGAnyObject.swift
//  Pods
//
//  Created by Sebastian Mamczak on 30.08.2017.
//
//

import Foundation
import SwiftyJSON

/// Message response object.
open class FGAnyObject: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGAnyObject"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        let json = JSON([:])
        return json
    }
    
}
