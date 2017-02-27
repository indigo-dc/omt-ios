//
//  FGRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation

/// Request helper class.
public protocol FGRequestHelper {
    
    /// Dispatch queue for background execution.
    func getBackgroundQueue() -> DispatchQueue
    
    /// Makes remote request and returns response in callback.
    func send<Value: FGObjectSerializable>(_ payload: FGRequestPayload, callback: @escaping FGRequestHelperCallback<Value>)
    
}
