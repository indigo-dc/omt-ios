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
    
    /// CustomStringConvertible.
    public override var description: String {
        return "FGRequestPayload { url: \(url), resourcePath: \(resourcePath), method: \(method) }"
    }
    
    // MARK: - Public methods
    
    public override func toURLRequest() throws -> URLRequest {
        var request = try super.toURLRequest()
        
        // add body
        if let body = self.body {
            do {
                request.httpBody = try body.serialize().rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            catch {
            }
        }
        
        return request
    }
    
}
