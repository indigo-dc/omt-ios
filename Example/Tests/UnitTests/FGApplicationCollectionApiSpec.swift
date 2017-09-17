//
//  FGApplicationCollectionApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 22.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGApplicationCollectionApiSpec: QuickSpec {
    override func spec() {
        let dummyHelper = DummyHelper()
        let dummyResolver = DummyResolver(baseUrl: Constants.notExistingServerUrl, versionID: "v1.0")
        let applicationCollectionApi = FGApplicationCollectionApi(resolver: dummyResolver, helper: dummyHelper)
        
        describe("FGTaskCollectionApi") {
            context("methods") {
                
                beforeEach {
                    dummyResolver.dummyError = nil
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyValue = nil
                    dummyHelper.dummyResponse = nil
                }
                
                it("should return network error on listAllApplications") {
                    
                    // prepare
                    dummyResolver.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "405 Method not allowed"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        applicationCollectionApi.listAllApplications { (response: FGApiResponse<FGApplicationCollection>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error).to(beNetworkError())
                            
                            done()
                        }
                    }
                }
                
                it("should return application list"){
                    
                    // prepare
                    let applicationJsonString = createApplicationString("4", name: "app", desc: "My desc")
                    let applicationCollectionJsonString = createApplicationCollectionString(applicationJsonString)
                    let applicationCollectionData = applicationCollectionJsonString.data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(applicationCollectionData) as FGApplicationCollection?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        applicationCollectionApi.listAllApplications { (response: FGApiResponse<FGApplicationCollection>) in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.value?.applications).toNot(beEmpty())
                            
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func makeNewTask(from task: FGTask) -> FGTask {
        task.id = "2"
        task.creation = Date()
        task.user = "user"
        task.status = .waiting
        task.inputFiles = task.inputFiles.map { $0.status = .needed; return $0 }
        task.outputFiles.append(FGOutputFile())
        task.links.append(FGApiLink())
        
        return task
    }
}
