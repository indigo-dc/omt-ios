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
        var payload = FGRequestHelperPayload(method: .get)
        payload.resourcePath = "tasks/\(id)"
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    /*
    /// This method will create a new task with a specific ID assigned by the user.
    /// If the id already exist the task is not modified but an error is returned to the user because the tasks are not modifiable but only some parameters which have specific APIs for their update.
    public func createTask(with task: FGTask, _ callback: @escaping FGApiResponseCallback<FGTask>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .put)
        payload.resourcePath = "tasks/\(task.id ?? "-1")"
        payload.addHeader("Content-Type", value: "application/vnd.indigo-datacloud.apiserver+json")
        payload.body = task
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
    /// This method will modify the task with a specific ID assigned by the user.
    /// Currently only the status can be modified and the only value accepted is CANCELLED.
    /// This has the effect to stop the task, free the associated resources and clean the temporary storage.
    public func modifyTask(with id: String, status: FGTaskStatus, _ callback: @escaping FGApiResponseCallback<FGTask>) {
        
        // prepare body
        let task = FGTask()
        task.status = status
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .patch)
        payload.resourcePath = "tasks/\(id)"
        payload.addHeader("Content-Type", value: "application/vnd.indigo-datacloud.apiserver+json")
        payload.body = task
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    */
    /// Deletes a task.
    public func deleteTask(with id: String, _ callback: @escaping FGApiResponseCallback<FGMessageObject>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .delete)
        payload.resourcePath = "tasks/\(id)"
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
}
