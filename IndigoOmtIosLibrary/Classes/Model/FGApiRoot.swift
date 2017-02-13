//
//  FGApiRoot.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.01.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway API root object
open class FGApiRoot: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    public var links: [FGApiLink] = []
    public var versions: [FGApiRootVersion] = []
    
    public var description: String {
        return "FGApiLink { links: \(links.count), versions: \(versions.count) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let linksArray = json["_links"].array,
            let versionsArray = json["versions"].array
        else {
            return nil
        }
        
        for linkJson in linksArray {
            if let link = FGApiLink(response: response, json: linkJson) {
                self.links.append(link)
            }
        }
        
        for versionJson in versionsArray {
            if let version = FGApiRootVersion(response: response, json: versionJson) {
                self.versions.append(version)
            }
        }
    }
    
}
