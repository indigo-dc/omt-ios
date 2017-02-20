//
//  FGTaskCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation

/// API for Future Gateway Task Collection.
open class FGTaskCollectionApi: FGAbstractResolvedApi {
    
    /// Retrieve the list of tasks submitted by the user defined in the token.
    /// The list includes all the submitted tasks to the system.
    /// If the search has to be limited to a subset the attribute filter has to be used.
    public func listAllTasks(_ callback: @escaping FGApiResponseCallback<FGTaskCollection>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .get)
        payload.resourcePath = "tasks"
        payload.addParam("user", value: self.username)
        payload.addParam("status", value: FGTaskStatus.any.rawValue)
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
    /// Create a new task.
    public func createTask(_ task: FGTask, callback: @escaping FGApiResponseCallback<FGTask>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .post)
        payload.resourcePath = "tasks"
        payload.addHeader("Content-Type", value: "application/vnd.indigo-datacloud.apiserver+json")
        payload.body = task
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
    /// Replacing the full list of task is not acceptable.
    /// A bulk operation can be performed using the PATCH method.
    public func replaceTaskList(_ taskCollection: FGTaskCollection, callback: @escaping FGApiResponseCallback<FGTaskCollection>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .put)
        payload.resourcePath = "tasks"
        payload.body = taskCollection
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    /*
    /// Adds multiple tasks.
    public func addMultipleTasks(_ taskCollection: FGTaskCollection, callback: @escaping FGApiResponseCallback<FGTaskCollection>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .patch)
        payload.resourcePath = "tasks"
        payload.addHeader("Content-Type", value: "application/vnd.indigo-datacloud.apiserver+json")
        payload.body = taskCollection
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    
    /// Remove all tasks
    public func deleteTaskList(_ callback: @escaping FGApiResponseCallback<FGEmptyObject>) {
        
        // prepare payload
        var payload = FGRequestHelperPayload(method: .delete)
        payload.resourcePath = "tasks"
        
        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }
    */
}
