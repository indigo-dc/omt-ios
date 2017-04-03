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
        let username = "test"
        let tokenProvider = DummyProvider()
        
        describe("FGFutureGateway.taskApi") {
            context("viewTaskDetails") {
                
                it("should view task details") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    
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
                    let fg = FGFutureGateway(url: baseURL, username: username, provider: tokenProvider)
                    let taskID = "1"
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.taskApi.viewTaskDetails(with: taskID) { (responseTask: FGApiResponse<FGTask>) in
                            
                            expect(responseTask.error).toNot(beNil())
                            expect(responseTask.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("deleteTask") {
                
            }
        }
    }
}
