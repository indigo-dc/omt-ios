//
//  FGAlamofireRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation
import Alamofire

/// Implementation of FGRequestHelper with Alamofire library.
public class FGAlamofireRequestHelper: FGRequestHelper {
    
    // MARK: - properties
    
    /// Session helper for Alamofire's SessionManager.
    public let session: FGSessionHelper
    
    /// Session manager.
    public let manager: SessionManager
    
    // MARK: - lifecycle
    
    public init(session: FGSessionHelper) {
        self.session = session
        self.manager = session.getSessionManager()
    }
    
    // MARK: - FGRequestHelper
    
    public func getBackgroundQueue() -> DispatchQueue {
        return session.getDispatchQueue()
    }
    
    public func send<Value: FGObjectSerializable>(_ payload: FGRequestHelperPayload, callback: @escaping FGRequestHelperCallback<Value>) {
        
        // check url
        guard payload.url != nil else {
            
            // return error
            let error = FGFutureGatewayError.urlIsEmpty(reason: "Payload has an empty URL")
            
            self.getBackgroundQueue().async {
                callback(FGRequestHelperResponse(request: nil, response: nil, data: nil, error: error, value: nil))
            }
            return
        }
        
        // acceptable content types
        let accept = payload.accept.isEmpty ? ["*/*"] : payload.accept
        
        // make request with validation
        self.manager
            .request(payload)
            .validate()
            .validate(contentType: accept)
            .responseObject(queue: self.session.getDispatchQueue())
        { (dataResponse: DataResponse<Value>) in
            
            
            
            
            print(dataResponse.request?.httpMethod)
            print(dataResponse.request?.allHTTPHeaderFields)
            
            if dataResponse.request?.httpBody != nil {
            print(
                String(data: dataResponse.request!.httpBody!, encoding: .utf8)
            )
            }
            
            
            
            
            // create response object
            let response = FGRequestHelperResponse(request: dataResponse.request,
                                                   response: dataResponse.response,
                                                   data: dataResponse.data,
                                                   error: dataResponse.error as? FGFutureGatewayError,
                                                   value: dataResponse.value)
            
            // execute
            callback(response)
        }
    }
    
}

extension FGRequestHelperPayload: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        
        // prepare url
        var requestUrl = self.url!
        if let path = self.resourcePath {
            requestUrl.appendPathComponent(path)
        }
        
        // create request
        var request = try URLRequest(url: requestUrl)
        
        // add method
        request.httpMethod = self.method.rawValue
        
        // add headers
        for (header, value) in self.headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        // add url params
        request = encodeParams(request, with: self.parameters)
        
        // add body
        if let body = self.body {
            request.httpBody = try body.serialize().rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        
        return request
    }
    
    private func encodeParams(_ request: URLRequest, with: Parameters) -> URLRequest {
        var mutableRequest = request
        
        if var urlComponents = URLComponents(url: mutableRequest.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryString = ""
            if let query = urlComponents.percentEncodedQuery {
                queryString += query
            }
            if parameters.isEmpty == false && queryString.isEmpty == false {
                queryString += "&"
            }
            queryString += makeQueryFromParams(parameters)
            
            urlComponents.percentEncodedQuery = queryString
            mutableRequest.url = urlComponents.url
        }
        
        return mutableRequest
    }
    
    private func makeQueryFromParams(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys {
            let value = parameters[key]!
            components += URLEncoding.default.queryComponents(fromKey: key, value: value)
        }
        
        return components.map { (k, v) in "\(k)=\(v)" }.joined(separator: "&")
    }
    
}
