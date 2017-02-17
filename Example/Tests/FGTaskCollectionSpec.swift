//
//  FGTaskCollectionSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 17.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGTaskCollectionSpec: QuickSpec {
    override func spec() {
        let response = HTTPURLResponse()
        let _ = FGTask()
        
        describe("FGTaskCollection") {
            context("methods") {
                
                it("should create object from json") {
                    
                    // prepare
                    let id = "111"
                    let application = "222"
                    let status = FGTaskStatus.running
                    let desc = "My description"
                    let user = "myuser"
                    let taskJsonString = createTaskString(id, application: application, status: status, desc: desc, user: user)
                    let taskCollectionJsonString = createTaskCollectionString(taskJsonString)
                    let json = JSON(parseJSON: taskCollectionJsonString)
                    
                    // test
                    let taskCollection = FGTaskCollection(response: response, json: json)
                    
                    // verify
                    expect(taskCollection).toNot(beNil())
                    expect(taskCollection?.tasks).toNot(beNil())
                    expect(taskCollection?.tasks[0].id).to(equal(id))
                    expect(taskCollection?.tasks[0].application).to(equal(application))
                    expect(taskCollection?.tasks[0].taskDescription).to(equal(desc))
                    expect(taskCollection?.tasks[0].status).to(equal(status))
                    expect(taskCollection?.tasks[0].user).to(equal(user))
                }
                
                it("should not create object from json") {
                    
                    // prepare
                    let jsonString = "not a json string"
                    let json = JSON(parseJSON: jsonString)
                    
                    // test
                    let taskCollection = FGTaskCollection(response: response, json: json)
                    
                    // verify
                    expect(taskCollection).to(beNil())
                }
                
                it("should serialize") {
                    
                    // prepare
                    let task = FGTask()
                    let taskCollection = FGTaskCollection()
                    taskCollection.tasks = [task]
                    
                    // test
                    let serialized = taskCollection.serialize()
                    
                    // verify
                    expect(serialized).toNot(beNil())
                    expect(serialized["tasks"].array).toNot(beEmpty())
                }
            }
        }
    }
}
