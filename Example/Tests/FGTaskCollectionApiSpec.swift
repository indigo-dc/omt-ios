//
//  FGTaskCollectionApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGTaskCollectionApiSpec: QuickSpec {
    override func spec() {
        let dummyHelper = DummyHelper()
        let dummyResolver = DummyResolver(baseUrl: Constants.notExistingServerUrl, versionID: "v1.0")
        let taskCollectionApi = FGTaskCollectionApi(username: "username", resolver: dummyResolver, helper: dummyHelper)
        
        describe("FGTaskCollectionApi") {
            context("methods") {
                
                beforeEach {
                    dummyResolver.dummyError = nil
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyValue = nil
                    dummyHelper.dummyResponse = nil
                }
                
                it("should return network error on replaceTaskList") {
                    
                    // prepare
                    dummyResolver.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "405 Method not allowed"))
                    let taskCollection = FGTaskCollection()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskCollectionApi.replaceTaskList(taskCollection) { (response: FGApiResponse<FGTaskCollection>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error).to(beNetworkError())
                            
                            done()
                        }
                    }
                }
                
                it("should return network error on task list"){
                    
                    // prepare
                    dummyHelper.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "405 Method not allowed"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error).to(beNetworkError())
                            
                            done()
                        }
                    }
                }
                
                it("should return task list"){
                    
                    // prepare
                    let taskJsonString = createTaskString("1", application: "2", status: .done, desc: "desc", user: "user")
                    let taskCollectionJsonString = createTaskCollectionString(taskJsonString)
                    let taskCollectionData = taskCollectionJsonString.data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(taskCollectionData) as FGTaskCollection?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.value?.tasks).toNot(beEmpty())
                            
                            done()
                        }
                    }
                }
                
                it("should create task") {
                    
                    // prepare
                    let inputFile = FGInputFile()
                    inputFile.name = "file1.txt"
                    let task = FGTask()
                    task.application = "1"
                    task.taskDescription = "Task description"
                    task.inputFiles = [ inputFile ]
                    dummyHelper.dummyValue = self.makeNewTask(from: task)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskCollectionApi.createTask(task) { (response: FGApiResponse<FGTask>) in
                            
                            // verify
                            let responseTask = response.value!
                            
                            expect(responseTask.id).toNot(beNil())
                            expect(responseTask.date).toNot(beNil())
                            expect(responseTask.user).toNot(beNil())
                            expect(responseTask.status?.rawValue).to(equal(FGTaskStatus.waiting.rawValue))
                            expect(responseTask.inputFiles[0].status).to(equal(FGInputFileStatus.needed))
                            expect(responseTask.outputFiles).toNot(beEmpty())
                            expect(responseTask.links).toNot(beEmpty())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func makeNewTask(from task: FGTask) -> FGTask {
        task.id = "2"
        task.date = Date()
        task.user = "user"
        task.status = .waiting
        task.inputFiles = task.inputFiles.map { $0.status = .needed; return $0 }
        task.outputFiles.append(FGOutputFile())
        task.links.append(FGApiLink())
        
        return task
    }
}
