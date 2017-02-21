//
//  FGApplicationSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 21.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApplicationSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGApplication") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let id = "111"
                    let name = "name"
                    let desc = "My description"
                    let jsonString = createApplicationString(id, name: name, desc: desc)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let application = FGApplication(response: response, json: json)
                    
                    // verify
                    expect(application).toNot(beNil())
                    expect(application?.id).to(equal(id))
                    expect(application?.name).to(equal(name))
                    expect(application?.applicationDescription).to(equal(desc))
                    expect(application?.enabled).toNot(beNil())
                    expect(application?.infrastructures).toNot(beEmpty())
                    expect(application?.parameters).toNot(beEmpty())
                    expect(application?.inputFiles).toNot(beEmpty())
                    expect(application?.links).toNot(beEmpty())
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let application = FGApplication(response: response, json: json)
                    
                    // verify
                    expect(application).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let application = FGApplication()
                    application.id = "1"
                    application.name = "name"
                    application.applicationDescription = "desc"
                    application.enabled = true
                    application.outcome = "JOB"
                    application.parameters = [FGParameter()]
                    application.infrastructures = [FGInfrastructure()]
                    application.inputFiles = [FGInputFile()]
                    application.links = [FGApiLink()]
                    
                    // test
                    let serialized = application.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["id"].string).toNot(beNil())
                    expect(serialized["name"].string).toNot(beNil())
                    expect(serialized["description"].string).toNot(beNil())
                    expect(serialized["enabled"].int).toNot(beNil())
                    expect(serialized["outcome"].string).toNot(beNil())
                    expect(serialized["parameters"].array).toNot(beNil())
                    expect(serialized["infrastructures"].array).toNot(beNil())
                    expect(serialized["input_files"].array).toNot(beNil())
                    expect(serialized["_links"].array).toNot(beNil())
                }
            }
        }
    }
}
