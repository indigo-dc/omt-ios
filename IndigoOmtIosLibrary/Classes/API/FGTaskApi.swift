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

    /// Retrieves the details of the specified task.
    public func viewTaskDetails(with id: String, _ callback: @escaping FGApiResponseCallback<FGTask>) {

        // prepare payload
        let payload = FGRequestPayload(method: .get)
        payload.resourcePath = "tasks/\(id)"

        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
    /// Deletes a task.
    public func deleteTask(with id: String, _ callback: @escaping FGApiResponseCallback<FGAnyObject>) {

        // prepare payload
        let payload = FGRequestPayload(method: .delete)
        payload.resourcePath = "tasks/\(id)"

        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }

}
