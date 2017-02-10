//
//  FGApiResolverSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import IndigoOmtIosLibrary

class FGApiResolverSpec: QuickSpec {
    override func spec() {
        let baseUrl = Constants.notExistingServerUrl
        let versionID = "v1.0"
        let dummyHelper = DummyHelper()
        var resolver: FGApiResolver?
        
        describe("FGApiResolver") {
            context("resolveUrlWithVersion") {
                beforeEach {
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyResponse = nil
                    dummyHelper.dummyValue = nil
                    resolver = FGApiResolver(baseUrl: baseUrl, versionID: versionID, helper: dummyHelper)
                }
                
                it("network error") {
                    
                    // prepare
                    dummyHelper.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "A network error"))
                    
                    // test
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("version not found") {
                    
                    // prepare
                    let notExistingVersion = "v2.0"
                    let data = createApiRootString(notExistingVersion).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beVersionNotFoundError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("version was found - no link") {
                    
                    // prepare
                    let data = createApiRootStringWithNoLinks(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beVersionNotFoundError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("version was found") {
                    
                    // prepare
                    let data = createApiRootString(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.description).toNot(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("version was found on second attempt") {
                    
                    // prepare
                    let data = createApiRootString(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        }
                    }
                    waitUntil(timeout: 10) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        }
                    }
                }

            }
        }
    }
}
