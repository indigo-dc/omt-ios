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
    return "{\"status\":\"\(status.rawValue)\",\"description\":\"\(desc)\",\"user\":\"\(user)\",\"creation\":\"2017-01-01T12:00:00Z\",\"id\":\"\(id)\",\"output_files\":[\(createOutputFileString("output1.txt", url: "file?path=/local&name=output1.txt"))],\"application\":\"\(application)\",\"_links\":[{\"href\":\"/v1.0/tasks/\(id)\",\"rel\":\"self\"},{\"href\":\"/v1.0/tasks/\(id)/input\",\"rel\":\"input\"}],\"arguments\":[\"arg1\",\"arg2\"],\"input_files\":[\(createInputFileString("input1.text", status: .needed))],\"last_change\":\"2017-01-01T12:00:00Z\",\"runtime_data\":[\(createRuntimeDataString("key", value: "value"))]}"
}

func createInputFileString(_ name: String, status: FGInputFileStatus) -> String {
    return "{\"status\":\"\(status.rawValue)\",\"name\":\"\(name)\"}"
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
        message.postfixMessage = "be json serialization error"
        if let actual = try expression.evaluate(),
            case FGFutureGatewayError.urlIsEmpty(reason: _) = actual {
            return true
        }
        return false
    }
}
