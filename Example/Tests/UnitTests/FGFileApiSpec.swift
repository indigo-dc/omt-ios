//
//  FGFileApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 29.03.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class FGFileApiSpec: QuickSpec {
    override func spec() {
        let dummyHelper = DummyHelper()
        let dummyResolver = DummyResolver(baseUrl: Constants.notExistingServerUrl, versionID: "v1.0")
        let fileApi = FGFileApi(username: "username", resolver: dummyResolver, helper: dummyHelper)
        
        describe("FGFileApi") {
            context("methods") {
                beforeEach {
                    dummyResolver.dummyError = nil
                    dummyHelper.dummyError = nil
                    dummyHelper.dummyResponse = nil
                    dummyHelper.dummyValue = nil
                }
                
                it("should return error when url is not resolved while downloading a file") {
                    
                    // prepare
                    let outputFile = FGOutputFile()
                    outputFile.name = "file1.txt"
                    outputFile.url = "http://upload-server.com/inbox"
                    let localFile = URL(string: "file:///tmp/file1.txt")!
                    dummyResolver.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "No url"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        fileApi.download(outputFile, to: localFile, { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        })
                    }
                }
                
                it("should return error when file was not found while downloading a file") {
                    
                    // prepare
                    let outputFile = FGOutputFile()
                    outputFile.name = "file1.txt"
                    outputFile.url = "http://upload-server.com/inbox"
                    let localFile = URL(string: "file:///tmp/file1.txt")!
                    dummyHelper.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "404 File not found"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        fileApi.download(outputFile, to: localFile, { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        })
                    }
                }
                
                it("should return empty object when file was downloaded") {
                    
                    // prepare
                    let outputFile = FGOutputFile()
                    outputFile.name = "file1.txt"
                    outputFile.url = "http://upload-server.com/inbox"
                    let localFile = URL(string: "file:///tmp/file1.txt")!
                    dummyHelper.dummyValue = FGEmptyObject()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        fileApi.download(outputFile, to: localFile, { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        })
                    }
                }
                
                it("should return error when file was not found while uploading a file") {
                    
                    // prepare
                    let inputFile = FGInputFile()
                    inputFile.name = "file1.txt"
                    let uploadLink = FGApiLink()
                    uploadLink.rel = "self"
                    uploadLink.href = "/v1.0/upload"
                    let localFile = URL(string: "file:///tmp/file1.txt")!
                    dummyHelper.dummyError = FGFutureGatewayError.network(error: DummyError(msg: "404 File not found"))
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        fileApi.upload(inputFile, to: uploadLink, from: localFile, { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).toNot(beNil())
                            expect(response.value).to(beNil())
                            
                            done()
                        })
                    }
                }
                
                it("should return empty object when file was uploaded") {
                    
                    // prepare
                    let inputFile = FGInputFile()
                    inputFile.name = "file1.txt"
                    let uploadLink = FGApiLink()
                    uploadLink.rel = "self"
                    uploadLink.href = "/v1.0/upload"
                    let localFile = URL(string: "file:///tmp/file1.txt")!
                    dummyHelper.dummyValue = FGEmptyObject()
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        fileApi.upload(inputFile, to: uploadLink, from: localFile, { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).to(beNil())
                            expect(response.value).toNot(beNil())
                            
                            done()
                        })
                    }
                }
                
            }
        }
    }
}
