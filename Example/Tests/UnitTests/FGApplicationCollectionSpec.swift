//
//  FGApplicationCollectionSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 21.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApplicationCollectionSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGApplicationCollection") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let id = "111"
                    let desc = "My description"
                    let name = "name"
                    let applicationJsonString = createApplicationString(id, name: name, desc: desc)
                    let taskCollectionJsonString = createApplicationCollectionString(applicationJsonString)
                    let json = JSON(parseJSON: taskCollectionJsonString)
                    
                    // test
                    let applicationCollection = FGApplicationCollection(response: response, json: json)
                    
                    // verify
                    expect(applicationCollection).toNot(beNil())
                    expect(applicationCollection?.applications).toNot(beNil())
                    expect(applicationCollection?.applications[0].id).to(equal(id))
                    expect(applicationCollection?.applications[0].name).to(equal(name))
                    expect(applicationCollection?.applications[0].applicationDescription).to(equal(desc))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let applicationCollection = FGApplicationCollection(response: response, json: json)
                    
                    // verify
                    expect(applicationCollection).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let application = FGApplication()
                    let applicationCollection = FGApplicationCollection()
                    applicationCollection.applications = [application]
                    
                    // test
                    let serialized = applicationCollection.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["applications"].array).toNot(beEmpty())
                }
            }
        }
    }
}
