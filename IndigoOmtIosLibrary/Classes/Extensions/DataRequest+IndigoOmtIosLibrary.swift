//
//  DataRequest+IndigoOmtIosLibrary.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 20.01.2017.
//
//

import Foundation
import Alamofire
import SwiftyJSON

/// Interface for SwiftyJSON deserializer.
public protocol FGObjectSerializable {
    
    init?(response: HTTPURLResponse, json: JSON)
}

/// Extension for deserializing SwiftyJSON objects.
public extension DataRequest {
    
    @discardableResult
    func responseObject<T: FGObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            return DataRequest.serializeFGObject(request: request, response: response, data: data, error: error)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public class func serializeFGObject<T: FGObjectSerializable>(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<T> {
        guard error == nil else {
            return .failure(FGFutureGatewayError.network(error: error!))
        }
        
        let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
        
        guard
            case let .success(jsonObject) = result,
            let swiftyJsonObject = JSON(rawValue: jsonObject)
            else {
                return .failure(FGFutureGatewayError.jsonSerialization(error: result.error!))
        }
        
        guard let response = response, let responseObject = T(response: response, json: swiftyJsonObject) else {
            return .failure(FGFutureGatewayError.objectSerialization(reason: "JSON could not be serialized to generic type: \(T.self)"))
        }
        
        return .success(responseObject)
    }
    
}
