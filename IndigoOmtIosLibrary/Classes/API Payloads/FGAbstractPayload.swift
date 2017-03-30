//
//  FGAbstractPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.02.2017.
//
//

import Foundation

/// HTTP methods enumeration.
public enum FGHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// Abstract Payload class.
open class FGAbstractPayload: CustomStringConvertible {
    
    // MARK: - properties
    
    /// The URL of the payload.
    public var url: URL?
    
    /// This path will be appended to the resolved URL.
    public var resourcePath: String?
    
    /// HTTP method of the payload.
    public var method: FGHTTPMethod
    
    /// HTTP request headers.
    public var headers: [String: String]
    
    /// URL parameters.
    public var parameters: [String: String]
    
    /// Accepted response encodings.
    public var accept: [String]
    
    /// CustomStringConvertible.
    public var description: String {
        return "\(String(describing: type(of: self))) { url: \(url), resourcePath: \(resourcePath), method: \(method) }"
    }
    
    // MARK: - lifecycle
    
    public init(method: FGHTTPMethod) {
        self.method = method
        self.headers = [:]
        self.parameters = [:]
        self.accept = []
    }
    
    /// MARK: - public methods
    
    public func addParam(_ key: String, value: String) {
        parameters[key] = value
    }
    
    public func addHeader(_ key: String, value: String) {
        headers[key] = value
    }
    
    public func addAccept(_ contentType: String) {
        accept.append(contentType)
    }
    
    public func toURLRequest() throws -> URLRequest {
        guard let payloadUrl = self.url else {
            throw FGFutureGatewayError.urlIsEmpty(reason: "Payload has an empty URL")
        }
        
        // prepare url
        var requestUrl = append(resourcePath: self.resourcePath, to: payloadUrl)
        
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
        
        return request
    }
    
    public func append(resourcePath: String?, to url: URL) -> URL {
        var mutableUrl = url
        
        guard
            let resourcePath = resourcePath,
            resourcePath.characters.isEmpty == false,
            let resourcePathURL = URL(string: resourcePath),
            let resourcePathComponents = URLComponents(url: resourcePathURL, resolvingAgainstBaseURL: false),
            var urlComponents = URLComponents(url: mutableUrl, resolvingAgainstBaseURL: false)
        else {
            return mutableUrl
        }
        
        // merge paths
        var path = ""
        path += urlComponents.path
        if path.hasSuffix("/") {
            // remove suffix
            let index = path.index(path.endIndex, offsetBy: -1)
            path = path.substring(to: index)
        }
        if resourcePathURL.path.hasPrefix("/") == false {
            // append suffix
            path += "/"
        }
        path += resourcePathURL.path
        urlComponents.path = path
        
        // merge query items
        var queryItems: [URLQueryItem] = []
        queryItems.append(contentsOf: urlComponents.queryItems ?? [])
        queryItems.append(contentsOf: resourcePathComponents.queryItems ?? [])
        urlComponents.queryItems = queryItems
        
        // update url
        if let url = urlComponents.url {
            mutableUrl = url
        }
        
        return mutableUrl
    }
    
    public func encodeParams(_ request: URLRequest, with params: [String: String]) -> URLRequest {
        var mutableRequest = request
        
        // make sure url and params are not empty
        if let url = mutableRequest.url, params.isEmpty == false {
            
            // all params to string
            let paramsAsString = params.map { (k, v) in "\(k)=\(v)" }.joined(separator: "&")
            
            // get url components
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                
                var queryString = ""
                
                // append existing query
                if let urlQuery = urlComponents.percentEncodedQuery {
                    queryString += urlQuery
                    queryString += "&"
                }
                
                // append params
                queryString += paramsAsString
                
                // update query
                urlComponents.percentEncodedQuery = queryString
                
                // update url
                mutableRequest.url = urlComponents.url
            }
        }
        
        return mutableRequest
    }
    
}
