//
//  ApplicationCollectionApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class ApplicationCollectionApiSpec: QuickSpec {
    override func spec() {
        let tokenProvider = DummyProvider()
        
        describe("FGFutureGateway.applicationCollection") {
            context("listAllApplications") {
                
                it("should list all applications") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.applicationCollection.listAllApplications { (response: FGApiResponse<FGApplicationCollection>) in
                            
                            expect(response.error).to(beNil())
                            expect(response.value?.applications).toNot(beEmpty())
                            expect(response.value?.description).toNot(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should return error when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.applicationCollection.listAllApplications { (response: FGApiResponse<FGApplicationCollection>) in
                            
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
