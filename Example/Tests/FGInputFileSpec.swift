//
//  FGInputFileSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGInputFileSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGInputFile") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let name = "file"
                    let status = FGInputFileStatus.ready
                    let jsonString = createInputFileString(name, status: status)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let inputFile = FGInputFile(response: response, json: json)
                    
                    // verify
                    expect(inputFile).toNot(beNil())
                    expect(inputFile?.name).to(equal(name))
                    expect(inputFile?.status).to(equal(status))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a valid json"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let inputFile = FGInputFile(response: response, json: json)
                    
                    // verify
                    expect(inputFile).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let name = "name"
                    let status = FGInputFileStatus.needed
                    let url = "file"
                    let inputFile = FGInputFile()
                    inputFile.name = name
                    inputFile.status = status
                    inputFile.url = url
                    
                    // test
                    let serialized = inputFile.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["name"].string).to(equal(name))
                    expect(serialized["status"].string).to(equal(status.rawValue))
                    expect(serialized["url"].string).to(equal(url))
                }
            }
        }
    }
}
