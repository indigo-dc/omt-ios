//
//  FGAlamofireRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation
import Alamofire
import XCGLogger

/// Implementation of FGRequestHelper with Alamofire library.
public class FGAlamofireRequestHelper: FGRequestHelper {

    // MARK: - properties

    /// Session helper for Alamofire's SessionManager.
    public let session: FGSessionHelper

    /// Session manager.
    public let manager: SessionManager

    // Logger instance.
    public var logger: XCGLogger?

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

        let dict: [String: Any?] = [
            "url": payload.url,
            "resourcePath": payload.resourcePath,
            "method": payload.method,
            "headers": payload.headers,
            "parameters": payload.parameters,
            "accept": payload.accept
        ]
        logger?.debug("Sending request:\n\(dict)")

        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept

        // make request with validation
        self.manager
            .request(payload)
            .validate()
            .validate(contentType: accept)
            .responseObject(queue: self.getBackgroundQueue()) { (dataResponse: DataResponse<Value>) in

            // create response object
            let response =
                FGRequestHelperResponse(request: dataResponse.request,
                                        response: dataResponse.response,
                                        data: dataResponse.data,
                                        error: dataResponse.error as? FGFutureGatewayError,
                                        value: dataResponse.value)

            self.logger?.debug("Got response: \(String(describing: dataResponse.response?.statusCode))")
            self.logger?.debug("error: \(String(describing: dataResponse.error))")
            if let data = dataResponse.data {
                let responseString = String(data: data, encoding: .utf8)?
                    .replacingOccurrences(of: "\n", with: "")
                    .replacingOccurrences(of: "\t", with: "")
                    .replacingOccurrences(of: "    ", with: "")
                self.logger?.debug("data: \(String(describing: responseString))\n")
            }
            
            callback(response)
        }
    }

    public func downloadFile(_ payload: FGDownloadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>) {

        let dict: [String: Any?] = [
            "url": payload.url,
            "resourcePath": payload.resourcePath,
            "method": payload.method,
            "headers": payload.headers,
            "parameters": payload.parameters,
            "accept": payload.accept,
            "destinationURL": payload.destinationURL
        ]
        logger?.debug("Download file request:\n\(dict)")
        
        // check file
        guard let destinationURL = payload.destinationURL else {

            // return error
            let error = FGFutureGatewayError.fileURLIsEmpty(reason: "Payload has an empty destination file URL")

            logger?.error("Download file error: \(error.localizedDescription)")

            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }

        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept

        // make request
        self.manager
            .download(payload, to: getDownloadDestination(destinationURL))
            .validate()
            .validate(contentType: accept)
            .response(queue: self.session.getDispatchQueue()) { (downloadResponse: DefaultDownloadResponse) in

                // get error and value
                var value: FGEmptyObject?
                var error: FGFutureGatewayError?

                if let downloadError = downloadResponse.error {
                    if downloadError is FGFutureGatewayError {
                        error = downloadError as? FGFutureGatewayError
                    } else {
                        error = FGFutureGatewayError.downloadFileError(error: downloadError)
                    }
                } else {
                    value = FGEmptyObject()
                }

                // create response object
                let response: FGRequestHelperResponse<FGEmptyObject> =
                    FGRequestHelperResponse(request: downloadResponse.request,
                                            response: downloadResponse.response,
                                            data: nil,
                                            error: error,
                                            value: value)

                self.logger?.debug("Download file response: \(String(describing: response.response?.statusCode))")
                self.logger?.debug("error: \(String(describing: response.error))")

                callback(response)
        }
    }

    public func uploadFile(_ payload: FGUploadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>) {

        let dict: [String: Any?] = [
            "url": payload.url,
            "resourcePath": payload.resourcePath,
            "method": payload.method,
            "headers": payload.headers,
            "parameters": payload.parameters,
            "accept": payload.accept,
            "destinationURL": payload.sourceURL
        ]
        logger?.debug("Upload file request:\n\(dict)")

        // check file
        guard let sourceURL = payload.sourceURL else {

            // return error
            let error = FGFutureGatewayError.fileURLIsEmpty(reason: "Payload has an empty source file URL")

            logger?.error("Upload file error: \(error.localizedDescription)")

            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }

        // check filename
        guard let uploadFilename = payload.uploadFilename else {

            // return error
            let error = FGFutureGatewayError.uploadFilenameIsEmpty(reason: "Payload has an empty upload filename")

            logger?.error("Upload file error: \(error.localizedDescription)")

            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }

        // make request and encode data
        self.manager.upload(
            multipartFormData: { multipartFormData in

                // add file
                multipartFormData.append(sourceURL, withName: "file[]", fileName: uploadFilename, mimeType: "application/octet-stream")

            },
            with: payload) { encodingResult in

                // check encoding result
                switch encodingResult {
                case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):

                    // get response
                    uploadRequest
                        .validate()
                        .responseObject { (dataResponse: DataResponse<FGUploadResponse>) in

                            // get error and value
                            var value: FGEmptyObject?
                            var error: FGFutureGatewayError?

                            if let uploadError = dataResponse.error {
                                error = uploadError as? FGFutureGatewayError
                            } else {
                                value = FGEmptyObject()
                            }

                            // return success
                            let response: FGRequestHelperResponse<FGEmptyObject> =
                                FGRequestHelperResponse(request: dataResponse.request,
                                                        response: dataResponse.response,
                                                        data: dataResponse.data,
                                                        error: error,
                                                        value: value)


                            self.logger?.debug("Upload file response: \(String(describing: response.response?.statusCode))")
                            self.logger?.debug("error: \(String(describing: response.error))")

                            callback(response)
                    }
                    break

                case .failure(let error):

                    self.logger?.error("Upload file multipart conversion error: \(error.localizedDescription)")

                    if let fgError = error as? FGFutureGatewayError {
                        callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: fgError, value: nil))
                        return
                    }

                    // return error
                    let error = FGFutureGatewayError.fileEncodingError(error: error)

                    callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))

                    break
                }
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
