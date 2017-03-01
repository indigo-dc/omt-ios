//
//  FGTask.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation
import SwiftyJSON

/// The current status of the task.
public enum FGTaskStatus: String {
    
    /// Value for any Task status.
    case any = "ANY"
    
    /// Task created but input still required.
    case waiting = "WAITING"
    
    /// Task ready to be scheduled to the infrastructure.
    case ready = "READY"
    
    /// Task ready to execute in the selected infrastructure.
    case scheduled = "SCHEDULED"
    
    /// In execution.
    case running = "RUNNING"
    
    /// Task completed.
    case done = "DONE"
    
    /// Some error prevent the task from the execution.
    case aborted = "ABORTED"
    
    /// Task deleted by the user.
    case cancelled = "CANCELLED"
}

/// Future Gateway Task object.
open class FGTask: FGObjectSerializable, CustomStringConvertible {
    
    // MARK: - properties
    
    /// The id of the task.
    public var id: String?
    
    /// An date when the task was created.
    public var creation: Date?
    
    /// An date when the task status was updated.
    public var lastChange: Date?
    
    /// The id of the application associated with the task.
    public var application: String?
    
    /// A user provided description of the task.
    public var taskDescription: String?
    
    /// The current status of the task.
    public var status: FGTaskStatus?
    
    /// The user name submitting the task. This is retrieved from the token and if provided has to coincide.
    public var user: String?
    
    /// Arguments to provide to the application.
    public var arguments: [String]  = []
    
    /// Input file for the application. When the task is create a list of filename is provided as input_files. These files have to be uploaded in order to make the task SCHEDULED. The task detail provide an object for the each input file with the attributes: name and status. The status can be NEEDED if the input file has not been provided or READY otherwise.
    public var inputFiles: [FGInputFile] = []
    
    /// Output files of the application. During the task creation the user can specify a list of files to retrieve after the execution. The task details provides an object for each output file containing the name and the URL for download.
    public var outputFiles: [FGOutputFile] = []
    
    /// Information of the running task provided back to the user. This is needed to allow users to interact with the application. As an example, for a task running a VM the runtime_data can contains the ip address and the credentials. The format is similar to parameters with the addition of two optional time fields: creation and last_change.
    public var runtimeData: [FGRuntimeDataParameter] = []
    
    /// Task links.
    public var links: [FGApiLink] = []
    
    /// CustomStringConvertible.
    public var description: String {
        return "FGTask { id: \(id), status: \(status), taskDescription: \(taskDescription) }"
    }
    
    // MARK: - lifecycle
    
    public required init?(response: HTTPURLResponse, json: JSON) {
        guard
            let id = json["id"].string,
            let status = FGTaskStatus(rawValue: json["status"].stringValue)
        else {
            return nil
        }
        
        self.id = id
        self.status = status
        self.taskDescription = json["description"].string
        self.creation = FGDateUtil.parseDate(json["creation"].string)
        self.lastChange = FGDateUtil.parseDate(json["last_change"].string)
        self.application = json["application"].string
        self.user = json["user"].string
        
        if let argumentsArray = json["arguments"].array {
            for argumentJson in argumentsArray {
                self.arguments.append(argumentJson.stringValue)
            }
        }
        if let inputFilesArray = json["input_files"].array {
            for inputFileJson in inputFilesArray {
                if let inputFile = FGInputFile(response: response, json: inputFileJson) {
                    self.inputFiles.append(inputFile)
                }
            }
        }
        if let outputFiles = json["output_files"].array {
            for outputFileJson in outputFiles {
                if let outputFile = FGOutputFile(response: response, json: outputFileJson) {
                    self.outputFiles.append(outputFile)
                }
            }
        }
        if let runtimeData = json["runtime_data"].array {
            for runtimeDataParameterJson in runtimeData {
                if let runtimeDataParameter = FGRuntimeDataParameter(response: response, json: runtimeDataParameterJson) {
                    self.runtimeData.append(runtimeDataParameter)
                }
            }
        }
        if let linksArray = json["_links"].array {
            for linkJson in linksArray {
                if let link = FGApiLink(response: response, json: linkJson) {
                    self.links.append(link)
                }
            }
        }
    }
    
    public init() {
        // empty
    }
    
    public func serialize() -> JSON {
        var json = JSON([:])
        
        if let id = self.id {
            json["id"].string = id
        }
        if let status = self.status {
            json["status"].string = status.rawValue
        }
        if let taskDescription = self.taskDescription {
            json["description"].string = taskDescription
        }
        if let creation = self.creation {
            json["creation"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ssZ", date: creation)
        }
        if let lastChange = self.lastChange {
            json["last_change"].string = FGDateUtil.format("yyyy-MM-ddTHH:mm:ssZ", date: lastChange)
        }
        if let application = self.application {
            json["application"].string = application
        }
        if let user = self.user {
            json["user"].string = user
        }
        
        if arguments.isEmpty == false {
            json["arguments"].arrayObject = arguments
        }
        if inputFiles.isEmpty == false {
            json["input_files"].arrayObject = inputFiles.map { $0.serialize().object }
        }
        if outputFiles.isEmpty == false {
            json["output_files"].arrayObject = outputFiles.map { $0.serialize().object }
        }
        if runtimeData.isEmpty == false {
            json["runtime_data"].arrayObject = runtimeData.map { $0.serialize().object }
        }
        if links.isEmpty == false {
            json["_links"].arrayObject = links.map { $0.serialize().object }
        }
        
        return json
    }
    
}
