//
//  FGInfrastructureSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 21.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGInfrastructureSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGInfrastructure") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let id = "111"
                    let name = "name"
                    let desc = "My description"
                    let jsonString = createInfrastructureString(id, name: name, desc: desc)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let infrastructure = FGInfrastructure(response: response, json: json)
                    
                    // verify
                    expect(infrastructure).toNot(beNil())
                    expect(infrastructure?.description).toNot(beNil())
                    expect(infrastructure?.id).to(equal(id))
                    expect(infrastructure?.name).to(equal(name))
                    expect(infrastructure?.infrastructureDescription).to(equal(desc))
                    expect(infrastructure?.creation).toNot(beNil())
                    expect(infrastructure?.enabled).toNot(beNil())
                    expect(infrastructure?.vinfra).toNot(beNil())
                    expect(infrastructure?.parameters).toNot(beEmpty())
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let infrastructure = FGInfrastructure(response: response, json: json)
                    
                    // verify
                    expect(infrastructure).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let infrastructure = FGInfrastructure()
                    infrastructure.id = "1"
                    infrastructure.name = "name"
                    infrastructure.infrastructureDescription = "desc"
                    infrastructure.enabled = true
                    infrastructure.vinfra = false
                    infrastructure.creation = Date()
                    infrastructure.parameters = [FGParameter()]
                    
                    // test
                    let serialized = infrastructure.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["id"].string).toNot(beNil())
                    expect(serialized["name"].string).toNot(beNil())
                    expect(serialized["description"].string).toNot(beNil())
                    expect(serialized["creation"].string).toNot(beNil())
                    expect(serialized["enabled"].int).toNot(beNil())
                    expect(serialized["vinfra"].bool).toNot(beNil())
                    expect(serialized["parameters"].array).toNot(beEmpty())
                }
            }
        }
    }
}
