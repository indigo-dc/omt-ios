//
//  FGEmptyObjectSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 15.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGEmptyObjectSpec: QuickSpec {
    override func spec() {
        describe("FGEmptyObject") {
            context("init") {
                
                it("Empty object when status code is invalid") {
                    
                    // prepare
                    let url = Constants.notExistingServerUrl
                    let statusCode = 404
                    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil)
                    let json = JSON(parseJSON: "{}")
                    
                    // test
                    let emptyObj = FGEmptyObject(response: response!, json: json)
                    
                    // verify
                    expect(emptyObj).to(beNil())
                }
                
                it("Not empty object when status code is invalid") {
                    
                    // prepare
                    let url = Constants.notExistingServerUrl
                    let statusCode = 204
                    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil)
                    let json = JSON(parseJSON: "{}")
                    
                    // test
                    let emptyObj = FGEmptyObject(response: response!, json: json)
                    
                    // verify
                    expect(emptyObj).toNot(beNil())
                }
                
                it("should serialzie to empty string") {
                    
                    // prepare
                    let empty = FGEmptyObject()
                    
                    // test
                    let result = empty.serialize()
                    
                    // verify
                    expect(result).to(beEmpty())
                }
            }
        }
    }
}
