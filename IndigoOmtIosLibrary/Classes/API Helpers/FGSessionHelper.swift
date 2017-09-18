//
//  FGSessionHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 24.01.2017.
//
//

import Foundation
import Alamofire
import XCGLogger

/// Session helper class for Alamofire's SessionsManager.
open class FGSessionHelper: RequestAdapter, RequestRetrier {

    // MARK: - properties

    /// Background queue.
    private let queue: DispatchQueue

    /// Access token provider.
    public let provider: FGAccessTokenProvider?

    /// Max number of retries.
    public var maxRetryCount: UInt {
        return 3
    }

    // Logger instance.
    public var logger: XCGLogger?

    // MARK: - lifecycle

    public init(queue: DispatchQueue, provider: FGAccessTokenProvider?) {
        self.queue = queue
        self.provider = provider
    }

    // MARK: - FGSessionHelper

    public func getDispatchQueue() -> DispatchQueue {
        return queue
    }

    public func getSessionManager() -> SessionManager {
        let sessionManager = SessionManager()
        sessionManager.adapter = self
        sessionManager.retrier = self
        return sessionManager
    }

    // MARK: - RequestAdapter

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let provider = self.provider {
            var mutableUrlRequest = urlRequest

            // turn off cache
            mutableUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData

            // add authorization token
            mutableUrlRequest.setValue("Bearer \(provider.getAccessToken())", forHTTPHeaderField: "Authorization")

            return mutableUrlRequest
        }

        return urlRequest
    }

    // MARK: - RequestRetrier

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        shouldRetry(retryCount: request.retryCount, urlResponse: request.task?.response, completion: completion)
    }

    public func shouldRetry(retryCount: UInt, urlResponse: URLResponse?, completion: @escaping RequestRetryCompletion) {
        if let provider = self.provider {

            guard
                retryCount < maxRetryCount,
                let httpResponse = urlResponse as? HTTPURLResponse,
                (httpResponse.statusCode == 401 || httpResponse.statusCode == 500)
            else {
                // do not retry
                completion(false, 0.0)

                self.logger?.error("Exceeded number of retries to get access token")

                return
            }

            // try to get a new access token
            provider.requestNewAccessToken { success in

                self.logger?.debug("Got new access token")

                completion(success, 0.0)
            }
        } else {
            // do not retry
            completion(false, 0.0)

            logger?.error("Will not retry to get access token")
        }
    }

}
