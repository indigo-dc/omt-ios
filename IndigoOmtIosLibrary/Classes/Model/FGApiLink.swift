//
//  FGApiLink.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway API root link object
open class FGApiLink: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    public var href: String = ""
    public var rel: String = ""
    
    public var description: String {
        return "FGApiLink { href: \(href), rel: \(rel) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let rel = json["rel"].string,
            let href = json["href"].string
        else {
            return nil
        }
        
        self.rel = rel
        self.href = href
    }
    
}
