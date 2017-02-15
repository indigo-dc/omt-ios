//
//  FGSessionHelperSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import IndigoOmtIosLibrary

class FGSessionHelperSpec: QuickSpec {
    override func spec() {
        let url = Constants.notExistingServerUrl
        let backgroundQueue = DispatchQueue.global()
        let dummyProvider = DummyProvider()
        let authSessionHelper = FGSessionHelper(queue: backgroundQueue, provider: dummyProvider)
        let unauthSessionHelper = FGSessionHelper(queue: backgroundQueue, provider: nil)
        
        describe("FGSessionHelper") {
            
            context("getDispatchQueue") {
                it("check equal") {
                    
                    // test
                    let queue = unauthSessionHelper.getDispatchQueue()
                    
                    // verify
                    expect(queue).to(equal(backgroundQueue))
                }
            }
            
            context("getSessionManager") {
                it("check delegates") {
                    
                    // test
                    let sessionManager = unauthSessionHelper.getSessionManager()
                    
                    // verify
                    expect(sessionManager.adapter).toNot(beNil())
                    expect(sessionManager.retrier).toNot(beNil())
                }
            }
            
            context("adapt") {
                
                it("should add token") {
                    
                    // prepare
                    let request = URLRequest(url: url)
                    
                    // test
                    do {
                        let resultRequest = try authSessionHelper.adapt(request)
                        
                        // verify
                        expect(resultRequest).notTo(equal(request))
                        expect(resultRequest.allHTTPHeaderFields?["Authorization"]).to(contain(dummyProvider.getAccessToken()))
                    }
                    catch {
                        fail()
                    }
                }
                
                it("should not add token") {
                    
                    // prepare
                    let request = URLRequest(url: url)
                    
                    // test
                    do {
                        let resultRequest = try unauthSessionHelper.adapt(request)
                        
                        // verify
                        expect(resultRequest).to(equal(request))
                        expect(resultRequest.allHTTPHeaderFields?["Authorization"]).to(beNil())
                    }
                    catch {
                        fail()
                    }
                }
            }
            
            context("should") {
                it("should try to retry") {
                    
                    // preapre
                    let sessionManager = unauthSessionHelper.getSessionManager()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        sessionManager.request(url).validate().responseString { (response: DataResponse<String>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                        
                    }
                }
            }
            
            context("shouldRetry") {
                
                let firstRetry: UInt = 0
                let response401 = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)
                
                it("should return false when no provider") {
                    
                    // test
                    unauthSessionHelper.shouldRetry(retryCount: firstRetry, urlResponse: response401) { success, _ in
                        
                        // verify
                        expect(success).toNot(beTrue())
                    }
                }
                
                it("should return false when empty response") {
                    
                    // test
                    authSessionHelper.shouldRetry(retryCount: firstRetry, urlResponse: nil) { success, _ in
                        
                        // verify
                        expect(success).toNot(beTrue())
                    }
                }
                
                it("should return false when exceeded max retry count") {
                    
                    // prepare
                    let currentRetry: UInt = authSessionHelper.maxRetryCount
                    
                    // test
                    authSessionHelper.shouldRetry(retryCount: currentRetry, urlResponse: nil) { success, _ in
                        
                        // verify
                        expect(success).toNot(beTrue())
                    }
                }
                
                it("should return false when status code is different than 401") {
                    
                    // prepare
                    let response500 = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
                    
                    // test
                    authSessionHelper.shouldRetry(retryCount: firstRetry, urlResponse: response500) { success, _ in
                        
                        // verify
                        expect(success).toNot(beTrue())
                    }
                }
                
                it("should return true when provider exists") {
                    
                    // test
                    authSessionHelper.shouldRetry(retryCount: firstRetry, urlResponse: response401) { success, _ in
                        
                        // verify
                        expect(success).to(beTrue())
                    }
                }
                
            }
            
        }
    }
}
