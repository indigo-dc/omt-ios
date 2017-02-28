//
//  FGAlamofireRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation
import Alamofire

/// Implementation of FGRequestHelper with Alamofire library.
public class FGAlamofireRequestHelper: FGRequestHelper {
    
    // MARK: - properties
    
    /// Session helper for Alamofire's SessionManager.
    public let session: FGSessionHelper
    
    /// Session manager.
    public let manager: SessionManager
    
    // MARK: - lifecycle
    
    public init(session: FGSessionHelper) {
        self.session = session
        self.manager = session.getSessionManager()
    }
    
    // MARK: - FGRequestHelper
    
    public func getBackgroundQueue() -> DispatchQueue {
        return session.getDispatchQueue()
    }
    
    public func send<Value: FGObjectSerializable>(_ payload: FGRequestPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        
        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept
        
        // make request with validation
        self.manager
            .request(payload)
            .validate()
            .validate(contentType: accept)
            .responseObject(queue: self.getBackgroundQueue())
        { (dataResponse: DataResponse<Value>) in
            
            // create response object
            let response = FGRequestHelperResponse(request: dataResponse.request,
                                                   response: dataResponse.response,
                                                   data: dataResponse.data,
                                                   error: dataResponse.error as? FGFutureGatewayError,
                                                   value: dataResponse.value)
            
            // execute
            callback(response)
        }
    }
    
    public func downloadFile(_ payload: FGDownloadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>) {
        
        // check file
        guard payload.destinationURL != nil else {
            
            // return error
            let error = FGFutureGatewayError.fileURLIsEmpty(reason: "Payload has an empty destination file URL")
            
            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }
        
        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept
        
        // make request
        self.manager
            .download(payload, to: getDownloadDestination(payload.destinationURL!))
            .validate()
            .validate(contentType: accept)
            .response(queue: self.session.getDispatchQueue())
            { (downloadResponse: DefaultDownloadResponse) in
                
                // get error
                var futureGatewayError: FGFutureGatewayError?
                if let error = downloadResponse.error {
                    futureGatewayError = FGFutureGatewayError.downloadFileError(error: error)
                }
                
                // create response object
                let response: FGRequestHelperResponse<FGEmptyObject> =
                    FGRequestHelperResponse(request: downloadResponse.request,
                                            response: downloadResponse.response,
                                            data: nil,
                                            error: futureGatewayError,
                                            value: FGEmptyObject())
                
                // execute
                callback(response)
        }
    }
    
    // MARK: - Private mthods
    
    private func getDownloadDestination(_ file: URL) -> DownloadRequest.DownloadFileDestination {
        return { _, _ in
            return (file, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
    
}

extension FGAbstractPayload: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        return try self.toURLRequest()
    }
    
}
