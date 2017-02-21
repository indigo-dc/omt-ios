//
//  FGMessageObjectSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 21.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGMessageObjectSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGMessageObject") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let jsonString = createMessageString("msg")
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let messageObject = FGMessageObject(response: response, json: json)
                    
                    // verify
                    expect(messageObject).toNot(beNil())
                    expect(messageObject?.message).toNot(beNil())
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let messageObject = FGMessageObject(response: response, json: json)
                    
                    // verify
                    expect(messageObject).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let messageObject = FGMessageObject()
                    messageObject.message = "msg"
                    
                    // test
                    let serialized = messageObject.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["message"].string).toNot(beNil())
                }
            }
        }
    }
}
