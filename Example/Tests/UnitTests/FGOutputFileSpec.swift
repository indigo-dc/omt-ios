//
//  FGOutputFileSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGOutputFileSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGOutputFile") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let name = "file"
                    let url = "location?name=file"
                    let jsonString = createOutputFileString(name, url: url)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let outputFile = FGOutputFile(response: response, json: json)
                    
                    // verify
                    expect(outputFile).toNot(beNil())
                    expect(outputFile?.name).to(equal(name))
                    expect(outputFile?.url).to(equal(url))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "{}"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let outputFile = FGOutputFile(response: response, json: json)
                    
                    // verify
                    expect(outputFile).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let name = "name"
                    let url = "url"
                    let outputFile = FGOutputFile()
                    outputFile.name = name
                    outputFile.url = url
                    
                    // test
                    let serialized = outputFile.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["name"].string).to(equal(name))
                    expect(serialized["url"].string).to(equal(url))
                }
            }
        }
    }
}
