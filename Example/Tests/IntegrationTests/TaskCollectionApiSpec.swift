//
//  TaskCollectionApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class TaskCollectionApiSpec: QuickSpec {
    override func spec() {
        let username = "test"
        let tokenProvider = DummyProvider()
        
        describe("FGFutureGateway.taskCollectionApi") {
            context("listAllTasks") {
                
                it("should list all tasks") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
                            
                            expect(response.error).to(beNil())
                            expect(response.value?.tasks).toNot(beEmpty())
                            expect(response.value?.description).toNot(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return error when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
                            
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("createTask") {
                
                it("should create task") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    let task = FGTask()
                    task.application = "2"
                    task.taskDescription = "Integration test iOS task"
                    let inputFile1 = FGInputFile()
                    inputFile1.name = "sayhello.sh"
                    let inputFile2 = FGInputFile()
                    inputFile2.name = "sayhello.txt"
                    task.inputFiles = [inputFile1, inputFile2]
                    
                    var newTask: FGTask?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.createTask(task) { (response: FGApiResponse<FGTask>) in
                            
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.value?.description).toNot(beNil())
                            
                            newTask = response.value
                            expect(newTask?.id).toNot(beNil())
                            expect(newTask?.links).toNot(beEmpty())
                            
                            done()
                        }
                    }
                    
                    // remove task
                    if let id = newTask?.id {
                        fg.taskApi.deleteTask(with: id, { _ in })
                    }
                }
                
                it("should return network error when invalid task was sent") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    let task = FGTask()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.createTask(task) { (response: FGApiResponse<FGTask>) in
                            
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("replaceTaskList") {
                
                it("should return network error method not allowed") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    let taskCollection = FGTaskCollection()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.replaceTaskList(taskCollection) { (response: FGApiResponse<FGTaskCollection>) in
                            
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
