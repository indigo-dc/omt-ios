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
        let filename: String = "file.txt"
        
        describe("FGAlamofireRequestHelper") {
            context("send") {
                beforeEach {
                    FileHelper.deleteFile(filename)
                }
                
                it("should return urlIsEmpty error") {
                    
                    // prepare
                    let url: URL? = nil
                    let payload = FGRequestPayload(method: .get)
                    payload.url = url
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
            
            context("upload") {
                
                it("should return urlIsEmpty error") {
                    
                    // prepare
                    let fileURL: URL? = nil
                    let payload = FGUploadPayload(method: .get)
                    payload.url = Constants.notExistingServerUrl
                    payload.sourceURL = fileURL
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.uploadFile(payload) { (response: FGRequestHelperResponse<FGEmptyObject>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            expect(response.error).to(beFileUrlIsEmptyError())
                            
                            done()
                        }
                    }
                }
                
                it("should return filename is empty error") {
                    
                    // prepare
                    let fileURL: URL? = URL(string: "file:///tmp/file1.txt")
                    let filename: String? = nil
                    let payload = FGUploadPayload(method: .get)
                    payload.url = Constants.notExistingServerUrl
                    payload.sourceURL = fileURL
                    payload.uploadFilename = filename
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.uploadFile(payload) { (response: FGRequestHelperResponse<FGEmptyObject>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            expect(response.error).to(beFilenameIsEmptyError())
                            
                            done()
                        }
                    }
                }
                
                it("should return file encoding error error") {
                    
                    // prepare
                    let fileURL: URL? = URL(string: "file:///tmp/file1.txt")
                    let payload = FGUploadPayload(method: .get)
                    payload.url = Constants.notExistingServerUrl
                    payload.sourceURL = fileURL
                    payload.uploadFilename = filename
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.uploadFile(payload) { (response: FGRequestHelperResponse<FGEmptyObject>) in
                            
                            // verify
                            expect(response.error).toNot(beNil())
                            expect(response.error?.localizedDescription).toNot(beNil())
                            expect(response.error).to(beFileEncodingError())
                            
                            done()
                        }
                    }
                }

                it("should upload file") {
                    
                    // prepare
                    FileHelper.createFile(filename)
                    let fileURL: URL? = FileHelper.pathToFile(filename)
                    let payload = FGUploadPayload(method: .get)
                    payload.url = Constants.notExistingServerUrl
                    payload.sourceURL = fileURL
                    payload.uploadFilename = filename
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        alamo.uploadFile(payload) { (response: FGRequestHelperResponse<FGEmptyObject>) in
                            
                            print(response.error)
                            
                            // verify
                            expect(response.error).to(beNil())
                            
                            done()
                        }
                    }
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}
