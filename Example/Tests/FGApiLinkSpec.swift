//
//  FGApiLinkSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApiLinkSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGApiLink") {
            context("methods") {
                
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
                
                it("should serialize") {
                    
                    // prepare
                    let rel = "self"
                    let href = "/here"
                    let apiLink = FGApiLink()
                    apiLink.rel = rel
                    apiLink.href = href
                    
                    // test
                    let serialized = apiLink.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["rel"].string).to(equal(rel))
                    expect(serialized["href"].string).to(equal(href))
                }
            }
        }
    }
}
