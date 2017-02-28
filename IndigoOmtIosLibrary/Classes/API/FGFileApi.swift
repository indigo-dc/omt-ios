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
    public func download(_ downloadableFile: FGDownloadableFile, to destination: URL, _ callback: @escaping FGDownloadPayloadResponseCallback) {
        
        // prepare payload
        let payload = FGDownloadPayload(method: .get)
        payload.url = self.resolver.baseUrl
        payload.resourcePath = downloadableFile.url
        payload.destinationURL = destination
        
        // send
        fetchResolvedUrlAndDownloadFile(payload, callback)
    }
    
    // MARK: - internal methods
    
    /// Fetches URL from resolver, updates URL in payload and downloads file
    func fetchResolvedUrlAndDownloadFile(_ payload: FGDownloadPayload, _ callback: @escaping FGApiResponseCallback<FGEmptyObject>) {
        self.resolver.resolveUrlWithVersion { response in
            
            // return error
            guard response.error == nil else {
                callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                return
            }
            
            // append api path to the url
            var mutablePayload = payload
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
    
}
