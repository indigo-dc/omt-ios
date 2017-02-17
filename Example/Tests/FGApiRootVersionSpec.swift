//
//  FGApiRootVersionSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApiRootVersionSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGApiRootVersion") {
            context("methods") {
                
                it("not nil") {
                    
                    // prepare
                    let str = "{\"status\": \"prototype\", \"updated\": \"2016-04-20\", \"build:\": \"v0.0.2-30-g37540b8-37540b8-37\", \"_links\": [{\"href\": \"v1.0\", \"rel\": \"self\"}], \"media-types\": {\"type\": \"application/json\"}, \"id\": \"v1.0\"}"
                    let json = JSON(parseJSON: str)
                    
                    // test
                    let apiRootVersion = FGApiRootVersion(response: response, json: json)
                    
                    // verify
                    expect(apiRootVersion).notTo(beNil())
                    expect(apiRootVersion?.description).notTo(beEmpty())
                }
                
                it("nil") {
                    
                    // prepare
                    let json = JSON(parseJSON: "")
                    
                    // test
                    let apiRootVersion = FGApiRootVersion(response: response, json: json)
                    
                    // verify
                    expect(apiRootVersion).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let id = "1"
                    let build = "build"
                    let status = "prototype"
                    let updated = Date()
                    let mediaTypes = [
                        "type": "application/json"
                    ]
                    let link = FGApiLink()
                    link.rel = "self"
                    link.href = "/"
                    let apiRootVersion = FGApiRootVersion()
                    apiRootVersion.id = id
                    apiRootVersion.build = build
                    apiRootVersion.status = status
                    apiRootVersion.updated = updated
                    apiRootVersion.mediaTypes = mediaTypes
                    apiRootVersion.links.append(link)
                    
                    // test
                    let serialized = apiRootVersion.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["id"].string).to(equal(id))
                    expect(serialized["build:"].string).to(equal(build))
                    expect(serialized["status"].string).to(equal(status))
                    expect(serialized["media-types"].dictionary).toNot(beEmpty())
                    expect(serialized["_links"].array).toNot(beEmpty())
                }
            }
            
        }
    }
}
