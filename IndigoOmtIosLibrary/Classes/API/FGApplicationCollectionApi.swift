//
//  FGApplicationCollectionApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 24.01.2017.
//
//

import Foundation

/// API for Future Gateway Application Collection.
open class FGApplicationCollectionApi: FGAbstractResolvedApi {

    // MARK: - public methods

    public func listAllApplications(_ callback: @escaping FGApiResponseCallback<FGApplicationCollection>) {

        // prepare payload
        let payload = FGRequestPayload(method: .get)
        payload.resourcePath = "applications"

        // send
        fetchResolvedUrlAndSendPayload(payload, callback)
    }

}
