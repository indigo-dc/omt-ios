//
//  FGRequestPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.02.2017.
//
//

import Foundation

/// Request payload class.
open class FGRequestPayload: FGAbstractPayload {
    
    /// MARK: - Properties
    
    /// Body of the payload.
    public var body: FGObjectSerializable?
    
    // MARK: - Public methods
    
    public override func toURLRequest() throws -> URLRequest {
        var request = try super.toURLRequest()
        
        // add body
        if let body = self.body {
            request.httpBody = try body.serialize().rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        
        return request
    }
    
}
