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
