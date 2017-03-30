//
//  FGApiRootSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 06.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApiRootSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGApiRoot") {
            context("methods") {
                
                it("not nil") {
                    
                    // prepare
                    let str = createApiRootString("v1.0")
                    let json = JSON(parseJSON: str)
                    
                    // test
                    let apiRoot = FGApiRoot(response: response, json: json)
                    
                    // verify
                    expect(apiRoot).notTo(beNil())
                    expect(apiRoot?.description).notTo(beEmpty())
                }
                
                it("nil") {
                    
                    // prepare
                    let json = JSON(parseJSON: "")
                    
                    // test
                    let apiRoot = FGApiRoot(response: response, json: json)
                    
                    // verify
                    expect(apiRoot).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let apiRoot = FGApiRoot()
                    apiRoot.links = [FGApiLink()]
                    apiRoot.versions = [FGApiRootVersion()]
                    
                    // test
                    let serialized = apiRoot.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["versions"].array).toNot(beEmpty())
                    expect(serialized["_links"].array).toNot(beEmpty())
                }
            }
        }
    }
}
