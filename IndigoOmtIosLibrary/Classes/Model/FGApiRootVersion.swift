//
//  FGApiRootVersion.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Future Gateway API root version object.
open class FGApiRootVersion: FGObjectSerializable, CustomStringConvertible {

    // MARK: - properties

    public var id: String = ""
    public var status: String = ""
    public var updated: Date = Date(timeIntervalSince1970: 0)
    public var build: String = ""
    public var links: [FGApiLink] = []
    public var mediaTypes: [String:String] = [:]

    public var description: String {
        return "FGApiRootVersion { id: \(id), status: \(status), updated: \(updated), "
            + "build: \(build), links: \(links.count), mediaTypes: \(mediaTypes.count) }"
    }

    // MARK: - lifecycle

    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let id = json["id"].string,
            let status = json["status"].string,
            let updated = FGDateUtil.parseDate(json["updated"].string),
            let linksArray = json["_links"].array,
            let mediaTypesDict = json["media-types"].dictionary
        else {
            return nil
        }

        self.id = id
        self.status = status
        self.updated = updated

        if let build = json["build:"].string {
            self.build = build
        }

        for linkJson in linksArray {
            if let link = FGApiLink(response: response, json: linkJson) {
                self.links.append(link)
            }
        }

        for (type, valueJson) in mediaTypesDict {
            self.mediaTypes[type] = valueJson.rawString()
        }
    }

    public init() {
        // empty
    }

    public func serialize() -> JSON {
        var json = JSON([:])
        json["id"].string = self.id
        json["status"].string = self.status
        json["build:"].string = self.build
        json["updated"].string = FGDateUtil.format("yyyy-MM-dd", date: self.updated)
        json["media-types"].dictionaryObject = self.mediaTypes
        json["_links"].arrayObject = self.links.map { $0.serialize().object }

        return json
    }

}
