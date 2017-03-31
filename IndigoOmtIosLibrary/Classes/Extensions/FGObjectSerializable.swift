//
//  FGObjectSerializable.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Interface for SwiftyJSON deserializer.
public protocol FGObjectSerializable {

    init?(response: HTTPURLResponse, json: JSON)

    func serialize() -> JSON

}
