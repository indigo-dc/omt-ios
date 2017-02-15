//
//  FGTaskSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 13.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGTaskSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        let _ = FGTask()
        
        describe("FGTask model") {
            context("FGTask") {
                
                it("should create object from json") {
                    
                    // prepare
                    let id = "111"
                    let application = "222"
                    let status = FGTaskStatus.running
                    let desc = "My description"
                    let user = "myuser"
                    let jsonString = createTaskString(id, application: application, status: status, desc: desc, user: user)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let task = FGTask(response: response, json: json)
                    
                    // verify
                    expect(task).toNot(beNil())
                    expect(task?.description).toNot(beNil())
                    
                    expect(task?.id).to(equal(id))
                    expect(task?.application).to(equal(application))
                    expect(task?.taskDescription).to(equal(desc))
                    expect(task?.status).to(equal(status))
                    expect(task?.user).to(equal(user))
                    
                    expect(task?.infrastructureTask).toNot(beEmpty())
                    expect(task?.date).toNot(beNil())
                    expect(task?.lastChange).toNot(beNil())
                    
                    expect(task?.arguments).toNot(beEmpty())
                    expect(task?.inputFiles).toNot(beEmpty())
                    expect(task?.outputFiles).toNot(beEmpty())
                    expect(task?.runtimeData).toNot(beEmpty())
                    expect(task?.runtimeData.first?.creation).toNot(beNil())
                    expect(task?.runtimeData.first?.lastChange).toNot(beNil())
                    expect(task?.links).toNot(beEmpty())
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let task = FGTask(response: response, json: json)
                    
                    // verify
                    expect(task).to(beNil())
                }
            }
            
            context("FGInputFile") {
                
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
                    let jsonString = "{}"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let inputFile = FGInputFile(response: response, json: json)
                    
                    // verify
                    expect(inputFile).to(beNil())
                }
            }
            
            context("FGOutputFile") {
                
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
                    let inputFile = FGOutputFile(response: response, json: json)
                    
                    // verify
                    expect(inputFile).to(beNil())
                }
            }
            
            context("FGRuntimeDataObject") {
                
                it("should create object from json") {
                    
                    // prepare
                    let name = "name"
                    let value = "value"
                    let jsonString = createRuntimeDataString(name, value: value)
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let runtimeData = FGRuntimeDataObject(response: response, json: json)
                    
                    // verify
                    expect(runtimeData).toNot(beNil())
                    expect(runtimeData?.name).to(equal(name))
                    expect(runtimeData?.value).to(equal(value))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "{}"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let inputFile = FGRuntimeDataObject(response: response, json: json)
                    
                    // verify
                    expect(inputFile).to(beNil())
                }
            }
        }
    }
}
