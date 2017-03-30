//
//  FGUploadResponse.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 28.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Upload file response object.
open class FGUploadResponse: FGObjectSerializable, CustomStringConvertible {
    
    /// MARK: - properties
    
    /// Array of uploaded files.
    public var files: [String] = []
    
    /// Upload message.
    public var message: String?
    
    /// Task identifier.
    public var task: String?
    
    /// The gestatus.
    public var gestatus: String?
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGUploadResponse { files: \(files.count) }"
    }
    
    /// MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let filesArray = json["files"].array
        else {
            return nil
        }
        
        for fileJson in filesArray {
            self.files.append(fileJson.stringValue)
        }
        if let message = json["message"].string {
            self.message = message
        }
        if let task = json["task"].string {
            self.task = task
        }
        if let gestatus = json["gestatus"].string {
            self.gestatus = gestatus
        }
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if files.isEmpty == false {
            json["files"].arrayObject = files
        }
        if let message = self.message {
            json["message"].string = message
        }
        if let task = self.task {
            json["task"].string = task
        }
        if let gestatus = self.gestatus {
            json["gestatus"].string = gestatus
        }
        
        return json
    }
    
}
