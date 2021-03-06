//
//  Global.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 09.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
import Alamofire
import IndigoOmtIosLibrary

func createApiRootString(_ version: String) -> String {
    return "{\"_links\": [{\"href\": \"/\", \"rel\": \"self\"}], \"versions\": [{\"status\": \"prototype\", \"updated\": \"2016-04-20\", \"build:\": \"v0.0.2-30-g37540b8-37540b8-37\", \"_links\": [{\"href\": \"v1.0\", \"rel\": \"self\"}], \"media-types\": {\"type\": \"application/json\"}, \"id\": \"\(version)\"}]}"
}

func createApiRootStringWithNoLinks(_ version: String) -> String {
    return "{\"_links\": [{\"href\": \"/\", \"rel\": \"self\"}], \"versions\": [{\"status\": \"prototype\", \"updated\": \"2016-04-20\", \"build:\": \"v0.0.2-30-g37540b8-37540b8-37\", \"_links\": [], \"media-types\": {\"type\": \"application/json\"}, \"id\": \"\(version)\"}]}"
}

func createTaskString(_ id: String, application: String, status: FGTaskStatus, desc: String, user: String) -> String {
    return "{\"status\":\"\(status.rawValue)\",\"description\":\"\(desc)\",\"user\":\"\(user)\",\"date\":\"2017-01-01T12:00:00Z\",\"id\":\"\(id)\",\"output_files\":[\(createOutputFileString("output1.txt", url: "file?path=/local&name=output1.txt"))],\"application\":\"\(application)\",\"_links\":[{\"href\":\"/v1.0/tasks/\(id)\",\"rel\":\"self\"},{\"href\":\"/v1.0/tasks/\(id)/input\",\"rel\":\"input\"}],\"arguments\":[\"arg1\",\"arg2\"],\"input_files\":[\(createInputFileString("input1.text", status: .needed))],\"last_change\":\"2017-01-01T12:00:00Z\",\"runtime_data\":[\(createRuntimeDataString("key", value: "value"))]}"
}

func createInputFileString(_ name: String, status: FGInputFileStatus) -> String {
    return "{\"status\":\"\(status.rawValue)\",\"name\":\"\(name)\", \"url\":\"file\"}"
}

func createOutputFileString(_ name: String, url: String) -> String {
    return "{\"url\":\"\(url)\",\"name\":\"\(name)\"}"
}

func createRuntimeDataString(_ name: String, value: String) -> String {
    return "{\"name\":\"\(name)\",\"value\":\"\(value)\",\"description\":\"This define something\",\"creation\":\"2014-11-11T12:12:00.421Z\",\"last_change\":\"2017-01-01T12:00:01.352Z\"}"
}

func createTaskCollectionString(_ task: String) -> String {
    return "{\"tasks\":[\(task)]}"
}

func createMessageString(_ msg: String) -> String {
    return "{\"message\":\"\(msg)\"}"
}

func createInfrastructureString(_ id: String, name: String, desc: String) -> String {
    return "{\"vinfra\":false,\"enabled\":1,\"id\":\"\(id)\",\"creation\":\"2016-12-07T14:48:56Z\",\"description\":\"\(desc)\",\"name\":\"\(name)\",\"parameters\":[{\"name\":\"name\",\"value\":\"jobtest\"}]}"
}

func createApplicationString(_ id: String, name: String, desc: String) -> String {
    return "{\"name\":\"\(name)\",\"input_files\":[\(createInputFileString("file", status: .needed))],\"id\":\"\(id)\",\"_links\":[{\"href\": \"/\", \"rel\": \"self\"}],\"description\":\"\(desc)\",\"parameters\":[{\"name\":\"jobdesc_executable\",\"value\":\"\\/bin\\/hostname\",\"description\":\"\"}],\"enabled\":1,\"outcome\":\"JOB\",\"infrastructures\":[\(createInfrastructureString("5", name: "myInfrastructure", desc: "My description"))]}"
}

func createApplicationCollectionString(_ application: String) -> String {
    return "{\"applications\":[\(application)]}"
}

func createUploadResponseString(_ files: [String], message: String, task: String, gestatus: String) -> String {
    return "{\"files\":[\(files.map { "\"\($0)\"" }.joined(separator: ","))], \"message\":\"\(message)\", \"task\":\"\(task)\", \"gestatus\":\"\(gestatus)\"}"
}

func makeObject<T: FGObjectSerializable>(_ data: Data) -> T? {
    return DataRequest.serializeFGObject(request: nil, response: HTTPURLResponse(), data: data, error: nil).value
}

func beVersionNotFoundError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be version not found error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.versionNotFound(reason: _) = actual {
            return true
        }
        return false
    }
}

func beNetworkError(test: @escaping (Error) -> () = { _ in }) -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be network error"
        if let actual = try expression.evaluate(),
            case let FGFutureGatewayError.network(error: error) = actual {
            test(error)
            return true
        }
        return false
    }
}

func beObjectSerializationError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be object serialization error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.objectSerialization(reason: _) = actual {
            return true
        }
        return false
    }
}

func beJsonSerializationError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be json serialization error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.jsonSerialization(error: _) = actual {
            return true
        }
        return false
    }
}

func beUrlIsEmptyError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be url is empty error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.urlIsEmpty(reason: _) = actual {
            return true
        }
        return false
    }
}

func beFileUrlIsEmptyError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be file url is empty error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.fileURLIsEmpty(reason: _) = actual {
            return true
        }
        return false
    }
}

func beFilenameIsEmptyError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be filename is empty error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.uploadFilenameIsEmpty(reason: _) = actual {
            return true
        }
        return false
    }
}

func beFileEncodingError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be file encoding error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.fileEncodingError(error: _) = actual {
            return true
        }
        return false
    }
}

func beDownloadFileError() -> MatcherFunc<Error> {
    return MatcherFunc { expression, message in
        message.postfixMessage = "be download file error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.downloadFileError(error: _) = actual {
            return true
        }
        return false
    }
}
