//
//  FGUnauthorizedSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// Unauthorized implementation of FGAbstractSessionHelper.
open class FGUnauthorizedSessionHelper: FGAbstractSessionHelper {
    
    // MARK: - FGRequestHandler
    
    public override func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var mutableUrlRequest = urlRequest
        
        // turn off cache
        mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        return mutableUrlRequest
    }
    
}
