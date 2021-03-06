//
//  FGRootApiResolver.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation

/// Resolves API URL with version.
open class FGRootApiResolver: FGAbstractApi, FGApiResolver {

    // MARK: - properties

    /// Base API URL.
    public private (set) var baseUrl: URL

    /// API version identifier.
    public private (set) var versionID: String

    /// Resolved API URL with version.
    private var resolvedUrl: URL?

    // MARK: - lifecycle

    public init(baseUrl: URL, versionID: String, helper: FGRequestHelper) {
        self.baseUrl = baseUrl
        self.versionID = versionID
        super.init(helper: helper)
    }

    // MARK: - FGApiResolver

    public func resolveUrlWithVersion(_ callback: @escaping FGApiResponseCallback<URL>) {

        // url was resolved earlier
        if let url = self.resolvedUrl {
            self.helper.getBackgroundQueue().async {
                callback(.success(url))
            }
            return
        }

        // prepare payload
        let payload = FGRequestPayload(method: .get)
        payload.url = self.baseUrl

        // resolve url
        self.helper.send(payload) { (response: FGRequestHelperResponse<FGApiRoot>) in

            // make sure there was no error
            guard response.error == nil else {
                callback(.failure(response.error!, response.errorResponseBody))
                return
            }

            // find requested version
            if let apiRootObj: FGApiRoot = response.value {
                for versionObj: FGApiRootVersion in apiRootObj.versions {

                    // version was found
                    if versionObj.id == self.versionID {

                        // get first link
                        if let linkObj: FGApiLink = versionObj.links.first {

                            // save resolved URL
                            self.resolvedUrl = self.baseUrl.appendingPathComponent(linkObj.href)

                            // return the URL
                            callback(.success(self.resolvedUrl!))
                            return
                        }
                    }
                }
            }

            // version was not found - raise error
            let error = FGFutureGatewayError.versionNotFound(reason: "Requested version \(self.versionID) was not found at \(self.baseUrl)")
            callback(.failure(error, nil))
        }
    }

}
