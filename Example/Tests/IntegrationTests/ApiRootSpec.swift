//
//  ApiRootSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class ApiRootSpec: QuickSpec {
    override func spec() {
        let tokenProvider = DummyProvider()
        let session = FGSessionHelper(queue: DispatchQueue.global(), provider: tokenProvider)
        let helper = FGAlamofireRequestHelper(session: session)
        
        describe("FGRootApiResolver") {
            context("resolveUrlWithVersion") {
                
                it("should resolve api root") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let version = "v1.0"
                    let resolver = FGRootApiResolver(baseUrl: baseURL, versionID: version, helper: helper)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        resolver.resolveUrlWithVersion { (response: FGApiResponse<URL>) in
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            expect(response.value?.description).toNot(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should not resolve api root when not existing version") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let version = "v2.0"
                    let resolver = FGRootApiResolver(baseUrl: baseURL, versionID: version, helper: helper)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        resolver.resolveUrlWithVersion { (response: FGApiResponse<URL>) in
                            expect(response.error).to(beVersionNotFoundError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                it("should not resolve api root when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let version = "v1.0"
                    let resolver = FGRootApiResolver(baseUrl: baseURL, versionID: version, helper: helper)
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        resolver.resolveUrlWithVersion { (response: FGApiResponse<URL>) in
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
