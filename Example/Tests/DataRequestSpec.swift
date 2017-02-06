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
import IndigoOmtIosLibrary

class DataRequestSpec: QuickSpec {
    override func spec() {
        describe("DataRequest") {
            
            context("responseObject") {
                
                it("network error") {
                    
                    // prepare
                    let invalidServerUrl = URL(string: "http://invalid_server.url")!
                    
                    // test
                    self.makeRequest(invalidServerUrl) { (response: DataResponse<FGApiRoot>) in
                        
                        // verify
                        expect(response.error).to(beNetworkError())
                        expect(response.error?.localizedDescription).toNot(beNil())
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
                
                it("no error") {
                    
                    // prepare
                    let data = "{\"_links\": [{\"href\": \"/\", \"rel\": \"self\"}], \"versions\": [{\"status\": \"prototype\", \"updated\": \"2016-04-20\", \"build:\": \"v0.0.2-30-g37540b8-37540b8-37\", \"_links\": [{\"href\": \"v1.0\", \"rel\": \"self\"}], \"media-types\": {\"type\": \"application/json\"}, \"id\": \"v1.0\"}]}".data(using: .utf8)
                    let response = HTTPURLResponse()
                    
                    // test
                    let result: Result<FGApiRoot> = DataRequest.serializeFGObject(request: nil, response: response, data: data, error: nil)
                    
                    // verify
                    expect(result.error).to(beNil())
                    expect(result.value).toNot(beNil())
                }
            }
        }
    }
    
    func makeRequest<T: FGObjectSerializable>(_ url: URL, callback: @escaping (DataResponse<T>) -> ()) {
        waitUntil(timeout: 30) { done in
            Alamofire
                .request(url)
                .validate()
                .responseObject
            { (response: DataResponse<T>) in
                callback(response)
                done()
            }
        }
    }
    
}

fileprivate func beNetworkError(test: @escaping (Error) -> () = { _ in }) -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be network error"
        if let actual = try expression.evaluate(),
            case let FGFutureGatewayError.network(error: error) = actual {
            test(error)
            return true
        }
        return false
    }
}

fileprivate func beObjectSerializationError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be object serialization error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.objectSerialization(reason: _) = actual {
            return true
        }
        return false
    }
}

fileprivate func beJsonSerializationError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be json serialization error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.jsonSerialization(error: _) = actual {
            return true
        }
        return false
    }
}
