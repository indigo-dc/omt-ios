//
//  FGFileApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 22.02.2017.
//
//

import Foundation

/// API for Future Gateway file management.
open class FGFileApi: FGAbstractResolvedApi {

    // MARK: - public methods

    /// Downloads file.
    // swiftlint:disable:next line_length
    public func download(_ downloadableFile: FGDownloadableFile, to destination: URL, _ callback: @escaping FGDownloadPayloadResponseCallback) {

        // prepare payload
        let payload = FGDownloadPayload(method: .get)
        payload.resourcePath = downloadableFile.url
        payload.destinationURL = destination

        // send
        fetchResolvedUrlAndDownloadFile(payload, callback)
    }

    /// Uploads file.
    // swiftlint:disable:next line_length
    public func upload(_ inputFile: FGInputFile, to uploadLink: FGApiLink, from source: URL, _ callback: @escaping FGUploadPayloadResponseCallback) {

        // prepare payload
        let payload = FGUploadPayload(method: .post)
        payload.resourcePath = uploadLink.href
        payload.sourceURL = source
        payload.uploadFilename = inputFile.name

        // send
        fetchBaseUrlAndUploadFile(payload, callback)
    }

    // MARK: - internal methods

    /// Fetches URL from resolver, updates URL in payload and downloads the file
    private func fetchResolvedUrlAndDownloadFile(_ payload: FGDownloadPayload, _ callback: @escaping FGApiResponseCallback<FGEmptyObject>) {
        self.resolver.resolveUrlWithVersion { response in

            // return error
            guard response.error == nil else {
                callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                return
            }

            // append api path to the url
            let mutablePayload = payload
            mutablePayload.url = response.value

            // send payload
            self.helper.downloadFile(mutablePayload) { (response: FGRequestHelperResponse<FGEmptyObject>) in

                // check for error
                guard response.error == nil else {
                    callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                    return
                }

                // return success
                callback(FGApiResponse.success(response.value!))
            }
        }
    }

    /// Fetches base URL from resolver, updates URL in payload and uploads the file.
    private func fetchBaseUrlAndUploadFile(_ payload: FGUploadPayload, _ callback: @escaping FGApiResponseCallback<FGEmptyObject>) {

        // append api path to the url
        let mutablePayload = payload
        mutablePayload.url = self.resolver.baseUrl

        // send payload
        self.helper.uploadFile(payload) { (response: FGRequestHelperResponse<FGEmptyObject>) in

            // check for error
            guard response.error == nil else {
                callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                return
            }

            // return success
            callback(FGApiResponse.success(response.value!))
        }
    }

}
