//
//  FGAbstractPayloadSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.03.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import Quick
import Nimble
import SwiftyJSON
import IndigoOmtIosLibrary

class FGAbstractPayloadSpec: QuickSpec {
    override func spec() {
        describe("FGAbstractPayloadSpec") {
            context("toURLRequest") {
                
                it("should throw exception when url is empty") {
                    
                    // prepare
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test and verify
                    expect{
                        
                        try payload.toURLRequest()
                        
                    }.to(throwError(errorType: FGFutureGatewayError.self))
                }
                
                it("should create request object") {
                    
                    // prepare
                    let url = Constants.notExistingServerUrl
                    let params = ["foo": "bar"]
                    let headers = ["Accept": "text/plain"]
                    
                    let payload = FGAbstractPayload(method: .get)
                    payload.url = url
                    payload.headers = headers
                    payload.parameters = params
                    
                    // test
                    var urlRequest: URLRequest?
                    do {
                        urlRequest = try payload.toURLRequest()
                    }
                    catch {
                        fail("Problem with payload")
                    }
                    
                    // verify
                    expect(urlRequest).toNot(beNil())
                    expect(urlRequest?.url?.absoluteString).to(contain(url.absoluteString))
                    expect(urlRequest?.allHTTPHeaderFields).to(equal(headers))
                }
            }
            
            context("encodeParams") {
                
                it("should return the same request when params are empty") {
                    
                    // prepare
                    let url = URL(string: "http://server.com")!
                    let urlRequest = URLRequest(url: url)
                    let params: [String: String] = [:]
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test
                    let resultRequest = payload.encodeParams(urlRequest, with: params)
                    
                    // verify
                    expect(resultRequest).to(equal(urlRequest))
                }
 
                it("should encode params") {
                    
                    // prepare
                    let url = URL(string: "http://server.com")!
                    let urlRequest = URLRequest(url: url)
                    let params: [String: String] = ["foo": "bar"]
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test
                    let resultRequest = payload.encodeParams(urlRequest, with: params)
                    
                    // verify
                    expect(resultRequest).toNot(equal(urlRequest))
                    expect(resultRequest.url?.absoluteString).to(contain(url.absoluteString))
                    expect(resultRequest.url?.absoluteString).to(contain(params.keys.first!))
                    expect(resultRequest.url?.absoluteString).to(contain(params.values.first!))
                }
                
                it("should encode params when url has already a query string") {
                    
                    // prepare
                    let url = URL(string: "http://server.com?test=1")!
                    let urlRequest = URLRequest(url: url)
                    let params: [String: String] = ["foo": "bar"]
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test
                    let resultRequest = payload.encodeParams(urlRequest, with: params)
                    
                    // verify
                    expect(resultRequest).toNot(equal(urlRequest))
                    expect(resultRequest.url?.absoluteString).to(contain(url.absoluteString))
                    expect(resultRequest.url?.absoluteString).to(contain(params.keys.first!))
                    expect(resultRequest.url?.absoluteString).to(contain(params.values.first!))
                }
            }
            
            context("append") {
                
                it("should return the same urlRequest when resource path is empty") {
                    
                    // prepare
                    let resourcePath: String? = nil
                    let url = Constants.notExistingServerUrl
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test
                    let resultUrl = payload.append(resourcePath: resourcePath, to: url)
                    
                    // verify
                    expect(resultUrl).to(equal(url))
                }
                
                it("should append resource path") {
                    
                    // prepare
                    let resourcePath = "files/category/pdfs"
                    let url = URL(string: "http://server.com/")!
                    let payload = FGAbstractPayload(method: .get)
                    
                    // test
                    let resultUrl = payload.append(resourcePath: resourcePath, to: url)
                    
                    // verify
                    expect(resultUrl).toNot(equal(url))
                    expect(resultUrl.absoluteString).to(contain(resourcePath))
                }
            }
        }
    }
}
