//
//  FGRuntimeDataObjectSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGRuntimeDataObjectSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        let _ = FGTask()
        
        describe("FGRuntimeDataObject") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let name = "name"
                    let value = "value"
                    let jsonString = createRuntimeDataString(name, value: value)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let runtimeData = FGRuntimeDataObject(response: response, json: json)
                    
                    // verify
                    expect(runtimeData).toNot(beNil())
                    expect(runtimeData?.name).to(equal(name))
                    expect(runtimeData?.value).to(equal(value))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "{}"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let inputFile = FGRuntimeDataObject(response: response, json: json)
                    
                    // verify
                    expect(inputFile).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let name = "name"
                    let value = "value"
                    let description = "description"
                    let runtimeDataObject = FGRuntimeDataObject()
                    runtimeDataObject.name = name
                    runtimeDataObject.value = value
                    runtimeDataObject.dataDescription = description
                    runtimeDataObject.creation = Date()
                    runtimeDataObject.lastChange = Date()
                    
                    // test
                    let serialized = runtimeDataObject.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["name"].string).to(equal(name))
                    expect(serialized["value"].string).to(equal(value))
                    expect(serialized["description"].string).to(equal(description))
                    expect(serialized["creation"].string).toNot(beNil())
                    expect(serialized["last_change"].string).toNot(beNil())
                }
            }
        }
    }
}
