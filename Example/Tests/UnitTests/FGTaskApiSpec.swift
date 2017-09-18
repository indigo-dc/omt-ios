//
//  FGTaskApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGTaskApiSpec: QuickSpec {
    override func spec() {
        let dummyHelper = DummyHelper()
        let dummyResolver = DummyResolver(baseUrl: Constants.notExistingServerUrl, versionID: "v1.0")
        let taskApi = FGTaskApi(resolver: dummyResolver, helper: dummyHelper)
        
        describe("FGTaskApi") {
            context("methods") {
                beforeEach {
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyValue = nil
                    dummyHelper.dummyResponse = nil
                }
                
                it("view task details") {
                    
                    // prepare
                    let taskID = "3"
                    let taskData = createTaskString(taskID, application: "2", status: .done, desc: "desc", user: "user").data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(taskData) as FGTask?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskApi.viewTaskDetails(with: taskID, { (response: FGApiResponse<FGTask>) in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.value?.id).to(equal(taskID))
                            
                            done()
                        })
                    }
                }
                
                it("should delete task") {
                    
                    // prepare
                    let taskID = "3"
                    dummyHelper.dummyValue = FGAnyObject()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        taskApi.deleteTask(with: taskID, { (response: FGApiResponse<FGAnyObject>) in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        })
                    }
                }
            }
        }
    }
}
