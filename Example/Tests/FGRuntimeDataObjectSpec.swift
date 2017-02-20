//
//  FGRuntimeDataParameterSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGRuntimeDataParameterSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        let _ = FGTask()
        
        describe("FGRuntimeDataParameter") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let name = "name"
                    let value = "value"
                    let jsonString = createRuntimeDataString(name, value: value)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let runtimeDataParameter = FGRuntimeDataParameter(response: response, json: json)
                    
                    // verify
                    expect(runtimeDataParameter).toNot(beNil())
                    expect(runtimeDataParameter?.name).to(equal(name))
                    expect(runtimeDataParameter?.value).to(equal(value))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "{}"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let runtimeDataParameter = FGRuntimeDataParameter(response: response, json: json)
                    
                    // verify
                    expect(runtimeDataParameter).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let name = "name"
                    let value = "value"
                    let description = "description"
                    let runtimeDataParameter = FGRuntimeDataParameter()
                    runtimeDataParameter.name = name
                    runtimeDataParameter.value = value
                    runtimeDataParameter.parameterDescription = description
                    runtimeDataParameter.creation = Date()
                    runtimeDataParameter.lastChange = Date()
                    
                    // test
                    let serialized = runtimeDataParameter.serialize()
                    
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
