//
//  FGAbstractResolvedApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 15.02.2017.
//
//

import Foundation

/// Abstract API with resolver.
open class FGAbstractResolvedApi: FGAbstractApi {

    // MARK: - properties

    /// API URL resolver.
    public let resolver: FGApiResolver

    // MARK: - lifecycle

    public init(resolver: FGApiResolver, helper: FGRequestHelper) {
        self.resolver = resolver
        super.init(helper: helper)
    }

    // MARK: - internal methods

    /// Fetches URL from resolver, updated payload URL and sends payload
    // swiftlint:disable:next line_length
    func fetchResolvedUrlAndSendPayload<Value: FGObjectSerializable>(_ payload: FGRequestPayload, _ callback: @escaping FGApiResponseCallback<Value>) {
        self.resolver.resolveUrlWithVersion { response in

            // return error
            guard response.error == nil else {
                callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                return
            }

            // append api path to the url
            let mutablePayload = payload
            mutablePayload.url = response.value

            // send payload
            self.helper.send(mutablePayload) { (response: FGRequestHelperResponse<Value>) in

                // check for error
                guard response.error == nil else {
                    callback(FGApiResponse.failure(response.error!, response.errorResponseBody))
                    return
                }

                // return success
                callback(FGApiResponse.success(response.value!))
            }
        }
    }

}
