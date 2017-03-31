//
//  FGMessageObject.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Message response object.
open class FGMessageObject: FGObjectSerializable, CustomStringConvertible {

    // MARK: - properties

    /// The message.
    public var message: String?

    /// CustomStringConvertible.
    public var description: String {
        return "FGMessageObject { message: \(self.message as String?) }"
    }

    // MARK: - lifecycle

    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let message = json["message"].string
        else {
            return nil
        }

        self.message = message
    }

    public init() {
        // empty
    }

    public func serialize() -> JSON {
        var json = JSON([:])

        if let message = self.message {
            json["message"].string = message
        }

        return json
    }

}
