//
//  FGTaskApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 15.02.2017.
//
//

import Foundation

/// API for Future Gateway Task.
open class FGTaskApi: FGAbstractResolvedApi {
    
    // MARK: - public methods
    
    public func deleteTask(with id: String, _ callback: @escaping FGApiResponseCallback<FGEmptyObject>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .delete)
        payload.resourcePath = "tasks/\(id)"
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
}
