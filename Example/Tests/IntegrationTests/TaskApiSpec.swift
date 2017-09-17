//
//  TaskApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class TaskApiSpec: QuickSpec {
    override func spec() {
        let tokenProvider = DummyProvider()
        
        describe("FGFutureGateway.taskApi") {
            context("viewTaskDetails") {
                
                it("should view task details") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
                            if let taskID = response.value?.tasks[0].id {
                                fg.taskApi.viewTaskDetails(with: taskID) { (responseTask: FGApiResponse<FGTask>) in
                                    
                                    expect(responseTask.error).to(beNil())
                                    expect(responseTask.value).toNot(beNil())
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
                
                it("should return error when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    let taskID = "1"
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskApi.viewTaskDetails(with: taskID) { (responseTask: FGApiResponse<FGTask>) in
                            
                            expect(responseTask.error).to(beNetworkError())
                            expect(responseTask.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("deleteTask") {
                
                it("should delete task") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    let task = self.getTask()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskCollectionApi.createTask(task) { (response: FGApiResponse<FGTask>) in
                            if let taskID = response.value?.id {
                                fg.taskApi.deleteTask(with: taskID) { (responseTask: FGApiResponse<FGAnyObject>) in
                                    
                                    expect(responseTask.error).to(beNil())
                                    expect(responseTask.value).toNot(beNil())
                                    
                                    done()
                                }
                            }
                        }
                    }
                }
                
                it("should return error when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    let taskID = "1"
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskApi.deleteTask(with: taskID) { (responseTask: FGApiResponse<FGAnyObject>) in
                            
                            expect(responseTask.error).to(beNetworkError())
                            expect(responseTask.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
    
    private func getTask() -> FGTask {
        let task = FGTask()
        task.application = "2"
        task.taskDescription = "Integration test iOS task"
        let inputFile1 = FGInputFile()
        inputFile1.name = "sayhello.sh"
        let inputFile2 = FGInputFile()
        inputFile2.name = "sayhello.txt"
        task.inputFiles = [inputFile1, inputFile2]
        return task
    }
}
