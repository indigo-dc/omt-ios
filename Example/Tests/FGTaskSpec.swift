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
        
        describe("FGTask") {
            context("methods") {
                
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
                    
                    expect(task?.creation).toNot(beNil())
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
                
                it("should serialize") {
                    
                    // prepare
                    let task = FGTask()
                    task.id = "1"
                    task.application = "2"
                    task.status = .waiting
                    task.user = "user"
                    task.taskDescription = "description"
                    task.creation = Date()
                    task.lastChange = Date()
                    task.arguments = ["arg"]
                    task.inputFiles = [FGInputFile()]
                    task.outputFiles = [FGOutputFile()]
                    task.runtimeData = [FGRuntimeDataParameter()]
                    task.links = [FGApiLink()]
                    
                    // test
                    let serialized = task.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["id"].string).toNot(beNil())
                    expect(serialized["application"].string).toNot(beNil())
                    expect(serialized["status"].string).toNot(beNil())
                    expect(serialized["user"].string).toNot(beNil())
                    expect(serialized["description"].string).toNot(beNil())
                    expect(serialized["creation"].string).toNot(beNil())
                    expect(serialized["last_change"].string).toNot(beNil())
                    expect(serialized["arguments"].array).toNot(beNil())
                    expect(serialized["input_files"].array).toNot(beNil())
                    expect(serialized["output_files"].array).toNot(beNil())
                    expect(serialized["runtime_data"].array).toNot(beNil())
                    expect(serialized["_links"].array).toNot(beNil())
                }
            }
        }
    }
}
