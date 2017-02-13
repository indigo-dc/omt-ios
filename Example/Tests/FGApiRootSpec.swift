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
        
        describe("FGApiRoot model") {
            context("FGApiRoot") {
                
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
            }
            
            context("FGApiLink") {
                
                it("not nil") {
                    
                    // prepare
                    let str = "{\"href\": \"/\", \"rel\": \"self\"}"
                    let json = JSON(parseJSON: str)
                    
                    // test
                    let apiRootLink = FGApiLink(response: response, json: json)
                    
                    // verify
                    expect(apiRootLink).notTo(beNil())
                    expect(apiRootLink?.description).notTo(beEmpty())
                }
                
                it("nil") {
                    
                    // prepare
                    let json = JSON(parseJSON: "")
                    
                    // test
                    let apiRootLink = FGApiLink(response: response, json: json)
                    
                    // verify
                    expect(apiRootLink).to(beNil())
                }
            }
            
            context("FGApiRootVersion") {
                
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
            }
            
        }
    }
}
