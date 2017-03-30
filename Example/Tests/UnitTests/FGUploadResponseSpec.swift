//
//  FGUploadResponseSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 02.03.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGUploadResponseSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        
        describe("FGUploadResponse") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let files = ["test.txt"]
                    let message = "My message"
                    let task = "123"
                    let gestatus = "waiting"
                    let uploadResponseStringJson = createUploadResponseString(files, message: message, task: task, gestatus: gestatus)
                    let json = JSON(parseJSON: uploadResponseStringJson)
                    
                    // test
                    let uploadResponse = FGUploadResponse(response: response, json: json)
                    
                    // verify
                    expect(uploadResponse).toNot(beNil())
                    expect(uploadResponse?.description).toNot(beEmpty())
                    expect(uploadResponse?.files).to(equal(files))
                    expect(uploadResponse?.message).to(equal(message))
                    expect(uploadResponse?.task).to(equal(task))
                    expect(uploadResponse?.gestatus).to(equal(gestatus))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let uploadResponse = FGUploadResponse(response: response, json: json)
                    
                    // verify
                    expect(uploadResponse).to(beNil())
                }
                
                it("should serialzie") {
                    
                    // prepare
                    let files = ["test.txt"]
                    let message = "My message"
                    let task = "123"
                    let gestatus = "waiting"
                    
                    let uploadResponse = FGUploadResponse()
                    uploadResponse.files = files
                    uploadResponse.message = message
                    uploadResponse.task = task
                    uploadResponse.gestatus = gestatus
                    
                    // test
                    let result = uploadResponse.serialize()
                    
                    // verify
                    expect(result).toNot(beNil())
                    expect(result["files"].array).toNot(beEmpty())
                    expect(result["message"].string).to(equal(message))
                    expect(result["task"].string).to(equal(task))
                    expect(result["gestatus"].string).to(equal(gestatus))
                }
            }
        }
    }
}
