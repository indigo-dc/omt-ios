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
    
    /// Request helper.
    public let helper: FGRequestHelper
    
    // MARK: - lifecycle
    
    public init(helper: FGRequestHelper) {
        self.helper = helper
    }
    
    /// MARK: - public methods
    
    public func inBackground(callback: @escaping () -> ()) {
        helper.getBackgroundQueue().async(execute: callback)
    }
    
    public func send<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        helper.send(payload, callback: callback)
    }
    
}
