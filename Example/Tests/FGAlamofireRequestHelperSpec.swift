//
//  FGAlamofireRequestHelperSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 10.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import IndigoOmtIosLibrary

class FGAlamofireRequestHelperSpec: QuickSpec {
    override func spec() {
        let backgroundQueue = DispatchQueue.global()
        let session = FGSessionHelper(queue: backgroundQueue, provider: nil)
        let alamo = FGAlamofireRequestHelper(session: session)
        
        describe("FGAlamofireRequestHelper") {
            context("send") {
                
                it("should return urlIsEmpty error") {
                    
                    // prepare
                    let payload = FGRequestPayload(method: .get)
                    payload.addAccept("application/json")
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.send(payload) { (response: FGRequestHelperResponse<FGApiRoot>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            expect(response.error).to(beUrlIsEmptyError())
                            
                            done()
                        }
                    }
                }
                
                it("should send request and return network error") {
                    
                    // prepare
                    let url = URL(string: Constants.notExistingServerUrl.absoluteString + "?secret=password")!
                    let param = "user"
                    let value = "myuser"
                    
                    let payload = FGRequestPayload(method: .get)
                    payload.url = url
                    payload.addParam(param, value: value)
                    payload.addHeader("Cache-Control", value: "no-cache")
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.send(payload) { (response: FGRequestHelperResponse<FGApiRoot>) in
                            
                            // verify
                            expect(payload.description).toNot(beNil())
                            expect(response.error).toNot(beNil())
                            expect(response.error).to(beNetworkError())
                            expect(response.request?.url?.absoluteString).to(contain(param))
                            expect(response.request?.url?.absoluteString).to(contain(value))
                            
                            done()
                        }
                    }
                }
                
                it("should send request with body") {
                    
                    // prepare
                    let link = FGApiLink()
                    link.rel = "self"
                    link.href = "/"
                    let param = "user"
                    let value = "myLogin"
                    
                    let payload = FGRequestPayload(method: .post)
                    payload.url = Constants.notExistingServerUrl
                    payload.addParam(param, value: value)
                    payload.body = link
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.send(payload) { (response: FGRequestHelperResponse<FGApiRoot>) in
                            
                            // verify
                            expect(response.request?.httpBody).toNot(beNil())
                            expect(response.request?.url?.absoluteString).to(contain(param))
                            expect(response.request?.url?.absoluteString).to(contain(value))
                            
                            done()
                        }
                    }
                }
            }
        }
    }
}
