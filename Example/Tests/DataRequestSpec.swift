//
//  DataRequestSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Alamofire
import SwiftyJSON
import IndigoOmtIosLibrary

class DataRequestSpec: QuickSpec {
    override func spec() {
        describe("DataRequest") {
            
            context("responseObject") {
                
                it("network error") {
                    
                    // prepare
                    let invalidServerUrl = URL(string: "http://invalid_server.url")!
                    
                    // test
                    waitUntil(timeout: 30) { done in
                        Alamofire.request(invalidServerUrl).validate().responseObject { (response: DataResponse<FGApiRoot>) in
                            
                            // verify
                            expect(response.error).to(beNetworkError())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("serializeFGObject") {
                
                it("json serialization error") {
                    
                    // prepare
                    let data = "This data is not json serializable".data(using: .utf8)
                    
                    // test
                    let result: Result<FGApiRoot> = DataRequest.serializeFGObject(request: nil, response: nil, data: data, error: nil)
                    
                    // verify
                    expect(result.error).toNot(beNil())
                    expect(result.error).to(beJsonSerializationError())
                    expect(result.error?.localizedDescription).toNot(beNil())
                }
                
                it("object serialization error") {
                    
                    // prepare
                    let data = "{\"info\": \"This json will not be serialize to object\"}".data(using: .utf8)
                    let response = HTTPURLResponse()
                    
                    // test
                    let result: Result<FGApiRoot> = DataRequest.serializeFGObject(request: nil, response: response, data: data, error: nil)
                    
                    // verify
                    expect(result.error).toNot(beNil())
                    expect(result.error).to(beObjectSerializationError())
                    expect(result.error?.localizedDescription).toNot(beNil())
                }
                
                it("no error when object in response") {
                    
                    // prepare
                    let data = createApiRootString("v1.0").data(using: .utf8)
                    let response = HTTPURLResponse()
                    
                    // test
                    let result: Result<FGApiRoot> = DataRequest.serializeFGObject(request: nil, response: response, data: data, error: nil)
                    
                    // verify
                    expect(result.error).to(beNil())
                    expect(result.value).toNot(beNil())
                }
                
                it("no error when empty response") {
                    
                    // prepare
                    let data = "".data(using: .utf8)
                    let url = URL(string: "http://example-server.com")!
                    let statusCode = 204
                    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil)
                    
                    // test
                    let result: Result<FGEmptyObject> = DataRequest.serializeFGObject(request: nil, response: response, data: data, error: nil)
                    
                    // verify
                    expect(result.error).to(beNil())
                    expect(result.value).toNot(beNil())
                }
            }
            
            context("FGEmptyObject") {
                it("Empty object when status code is invalid") {
                    
                    // prepare
                    let url = URL(string: "http://example-server.com")!
                    let statusCode = 404
                    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil)
                    let json = JSON("{}")
                    
                    // test
                    let emptyObj = FGEmptyObject(response: response!, json: json)
                    
                    // verify
                    expect(emptyObj).to(beNil())
                }
                
                it("Not empty object when status code is invalid") {
                    
                    // prepare
                    let url = URL(string: "http://example-server.com")!
                    let statusCode = 204
                    let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "1.0", headerFields: nil)
                    let json = JSON("{}")
                    
                    // test
                    let emptyObj = FGEmptyObject(response: response!, json: json)
                    
                    // verify
                    expect(emptyObj).toNot(beNil())
                }
                
            }
        }
    }
}
