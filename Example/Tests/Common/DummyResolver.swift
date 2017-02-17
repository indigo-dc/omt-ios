//
//  DummyResolver.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 16.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary

class DummyResolver: FGApiResolver {
    
    var baseUrl: URL
    var versionID: String
    var dummyError: FGFutureGatewayError?
    
    init(baseUrl: URL, versionID: String) {
        self.baseUrl = baseUrl
        self.versionID = versionID
    }
    
    func resolveUrlWithVersion(_ callback: @escaping (FGApiResponse<URL>) -> ()) {
        let url = self.baseUrl.appendingPathComponent(versionID)
        
        if let error = dummyError {
            callback(FGApiResponse.failure(error, nil))
        }
        else {
            callback(FGApiResponse.success(url))
        }
    }
    
}
