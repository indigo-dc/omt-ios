//
//  FGTaskCollection.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 02.02.2017.
//
//

import Foundation
import SwiftyJSON

/// Collection of FGTasks.
open class FGTaskCollection: FGObjectSerializable, CustomStringConvertible {
    
    /// MARK: - properties
    
    /// Tasks collection.
    public var tasks: [FGTask] = []
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGTaskCollection { tasks: \(tasks.count) }"
    }
    
    /// MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let tasksArray = json["tasks"].array
        else {
            return nil
        }
        
        for taskJson in tasksArray {
            if let task = FGTask(response: response, json: taskJson) {
                self.tasks.append(task)
            }
        }
    }
    
    public init() {
        // empty
    }
    
}
