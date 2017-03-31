//
//  FGApplicationCollection.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Collection of FGApplication.
open class FGApplicationCollection: FGObjectSerializable, CustomStringConvertible {

    /// MARK: - properties

    /// Applications collection.
    public var applications: [FGApplication] = []

    /// CustomStringConvertible.
    public var description: String {
        return "FGApplicationCollection { applications: \(applications.count) }"
    }

    /// MARK: - lifecycle

    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let applicationsArray = json["applications"].array
            else {
                return nil
        }

        for taskJson in applicationsArray {
            if let application = FGApplication(response: response, json: taskJson) {
                self.applications.append(application)
            }
        }
    }

    public init() {
        // empty
    }

    public func serialize() -> JSON {
        var json = JSON([:])

        if applications.isEmpty == false {
            json["applications"].arrayObject = applications.map { $0.serialize().object }
        }

        return json
    }

}
