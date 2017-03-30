//
//  FGRootApiResolver.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import IndigoOmtIosLibrary

class FGRootApiResolverSpec: QuickSpec {
    override func spec() {
        let baseUrl = Constants.notExistingServerUrl
        let versionID = "v1.0"
        let dummyHelper = DummyHelper()
        var resolver: FGApiResolver?
        
        describe("FGRootApiResolver") {
            context("resolveUrlWithVersion") {
                beforeEach {
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyResponse = nil
                    dummyHelper.dummyValue = nil
                    resolver = FGRootApiResolver(baseUrl: baseUrl, versionID: versionID, helper: dummyHelper)
                }
                
                it("should return network error") {
                    
                    // prepare
                    dummyHelper.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "A network error"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNetworkError())
                            expect(response.errorResponseBody).to(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return json error with body") {
                    
                    // prepare
                    dummyHelper.dummyError = FGFutureGatewayError.jsonSerialization(error: DummyError(msg: "Service is not available"))
                    dummyHelper.dummyErrorResponseBody = "{\"message\":\"Please check later\"}"
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beJsonSerializationError())
                            expect(response.errorResponseBody).toNot(beNil())
                            expect(response.description).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return version not found") {
                    
                    // prepare
                    let notExistingVersion = "v2.0"
                    let data = createApiRootString(notExistingVersion).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beVersionNotFoundError())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return version was found - no link") {
                    
                    // prepare
                    let data = createApiRootStringWithNoLinks(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beVersionNotFoundError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return version was found") {
                    
                    // prepare
                    let data = createApiRootString(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.errorResponseBody).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.description).toNot(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return version was found on second attempt") {
                    
                    // prepare
                    let data = createApiRootString(versionID).data(using: .utf8)!
                    dummyHelper.dummyValue = makeObject(data) as FGApiRoot?
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        resolver?.resolveUrlWithVersion { response in
                            
                            // verify
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        }
                    }
                    waitUntil(timeout: 60) { done in
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
