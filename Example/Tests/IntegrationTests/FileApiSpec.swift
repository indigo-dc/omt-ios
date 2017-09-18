//
//  FileApiSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import IndigoOmtIosLibrary

class FileApiSpec: QuickSpec {
    override func spec() {
        let tokenProvider = DummyProvider()
        
        describe("FGFutureGateway.fileApi") {
            context("downloadFile") {
                
                it("should download file") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    let filename = "sayhello.txt"
                    FileHelper.createFile(filename)
                    let inputFile = FGInputFile()
                    inputFile.name = filename
                    let link = FGApiLink()
                    let localFile = FileHelper.pathToFile(filename)!
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        self.createTask(fg) { (task) in
                            link.href = task.links.filter({ link in return link.rel == "input" }).first!.href
                            
                            fg.fileApi.upload(inputFile, to: link, from: localFile) { (response: FGApiResponse<FGEmptyObject>) in
                                fg.taskApi.viewTaskDetails(with: task.id!) { (responseTask: FGApiResponse<FGTask>) in
                                    let files = responseTask.value?.inputFiles.filter { inf in return inf.status == .ready }
                                    if let downloadableFile = files?.first {
                                        
                                        let destination = FileHelper.pathToFile("destination.txt")!
                                        fg.fileApi.download(downloadableFile, to: destination) { (downloadResponse: FGApiResponse<FGEmptyObject>) in
                                            
                                            expect(downloadResponse.error).to(beNil())
                                            expect(downloadResponse.value).toNot(beNil())
                                            
                                            done()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // clean
                    FileHelper.deleteFile(filename)
                }
                
                it("should not download file when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    let filename = "text.txt"
                    let inputFile = FGInputFile()
                    inputFile.name = filename
                    let localFile = FileHelper.pathToFile(filename)!
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.fileApi.download(inputFile, to: localFile) { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                }
            }
            
            context("uploadFile") {
                
                it("should upload file") {
                    
                    // prepare
                    let baseURL = Constants.integrationServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    let filename = "sayhello.txt"
                    FileHelper.createFile(filename)
                    let inputFile = FGInputFile()
                    inputFile.name = filename
                    let link = FGApiLink()
                    let localFile = FileHelper.pathToFile(filename)!
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        self.createTask(fg) { (task) in
                            link.href = task.links.filter({ link in return link.rel == "input" }).first!.href
                            
                            fg.fileApi.upload(inputFile, to: link, from: localFile) { (response: FGApiResponse<FGEmptyObject>) in
                                
                                expect(response.error).to(beNil())
                                expect(response.value).toNot(beNil())
                                
                                done()
                            }
                        }
                    }
                    
                    // clean
                    FileHelper.deleteFile(filename)
                }
                
                it("should not upload file when server is down") {
                    
                    // prepare
                    let baseURL = Constants.notExistingServerUrl
                    let fg = FGFutureGateway(url: baseURL, provider: tokenProvider)
                    
                    let filename = "sayhello.txt"
                    FileHelper.createFile(filename)
                    let inputFile = FGInputFile()
                    inputFile.name = filename
                    let link = FGApiLink()
                    let localFile = FileHelper.pathToFile(filename)!
                    
                    // test
                    waitUntil(timeout: 60) { done in
                        
                        fg.fileApi.upload(inputFile, to: link, from: localFile) { (response: FGApiResponse<FGEmptyObject>) in
                            
                            expect(response.error).to(beNetworkError())
                            expect(response.value).to(beNil())
                            
                            done()
                        }
                    }
                    
                    // clean
                    FileHelper.deleteFile(filename)
                }
            }
        }
    }
    
    private func createTask(_ fg: FGFutureGateway, _ callback: @escaping (FGTask) -> ()) {
        fg.taskCollectionApi.createTask(getTask()) { (response: FGApiResponse<FGTask>) in
            if let task = response.value {
                callback(task)
            }
        }
    }
    
    private func removeTask(_ fg: FGFutureGateway, _ task: FGTask) {
        fg.taskApi.deleteTask(with: task.id ?? "") { _ in }
    }
    
    private func getTask() -> FGTask {
        let task = FGTask()
        task.application = "2"
        task.taskDescription = "Integration test iOS task"
        let inputFile1 = FGInputFile()
        inputFile1.name = "sayhello.sh"
        let inputFile2 = FGInputFile()
        inputFile2.name = "sayhello.txt"
        task.inputFiles = [inputFile1, inputFile2]
        return task
    }
}
