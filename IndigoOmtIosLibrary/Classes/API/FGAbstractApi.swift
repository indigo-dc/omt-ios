//
//  FGAbstractApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation
import Alamofire

/// Abstract class for any API implementation.
open class FGAbstractApi {
    
    // MARK: - properties
    
    /// Alamofire session manager.
    public let manager: SessionManager
    
    /// Dispatch queue for remote requests.
    public let queue: DispatchQueue
    
    // MARK: - lifecycle
    
    public init(helper: FGSessionHelper) {
        self.manager = helper.getSessionManager()
        self.queue = helper.getDispatchQueue()
    }
    
}
