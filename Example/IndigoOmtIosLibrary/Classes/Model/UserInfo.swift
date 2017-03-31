//
//  UserInfo.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 25.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary
import SwiftyJSON

class UserInfo: NSObject, NSCoding, FGObjectSerializable {

    // MARK: - properties

    public var name: String = ""
    public var givenName: String = ""
    public var familyName: String = ""
    public var preferredUsername: String = ""
    public var organisationName: String = ""
    public var sub: String = ""
    public var updatedAt: Date = Date(timeIntervalSince1970: 0)
    public var groups: [String] = []

    override var description: String {
        return "UserInfo { name: \(name), preferredUsername: \(preferredUsername) }"
    }

    // MARK: - lifecycle

    required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let name = json["name"].string,
            let givenName = json["given_name"].string,
            let familyName = json["family_name"].string,
            let preferredUsername = json["preferred_username"].string,
            let organisationName = json["organisation_name"].string,
            let sub = json["sub"].string,
            let updatedAt = FGDateUtil.parseDate(json["updated_at"].string),
            let groups = json["groups"].array
        else {
            return nil
        }

        self.name = name
        self.givenName = givenName
        self.familyName = familyName
        self.preferredUsername = preferredUsername
        self.organisationName = organisationName
        self.sub = sub
        self.updatedAt = updatedAt
        for groupJson in groups {
            self.groups.append(groupJson.stringValue)
        }
    }

    func serialize() -> JSON {
        return JSON([:])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        name = aDecoder.decodeObject(forKey: "name") as! String
        givenName = aDecoder.decodeObject(forKey: "givenName") as! String
        familyName = aDecoder.decodeObject(forKey: "familyName") as! String
        preferredUsername = aDecoder.decodeObject(forKey: "preferredUsername") as! String
        organisationName = aDecoder.decodeObject(forKey: "organisationName") as! String
        sub = aDecoder.decodeObject(forKey: "sub") as! String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! Date
        groups = aDecoder.decodeObject(forKey: "groups") as! [String]

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(givenName, forKey: "givenName")
        aCoder.encode(familyName, forKey: "familyName")
        aCoder.encode(preferredUsername, forKey: "preferredUsername")
        aCoder.encode(organisationName, forKey: "organisationName")
        aCoder.encode(sub, forKey: "sub")
        aCoder.encode(updatedAt, forKey: "updatedAt")
        aCoder.encode(groups, forKey: "groups")
    }

}
