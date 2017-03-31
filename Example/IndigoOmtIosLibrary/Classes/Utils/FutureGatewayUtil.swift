//
//  FutureGatewayUtil.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import IndigoOmtIosLibrary

class FutureGatewayUtil {

    // MARK: - properties

    /// Default instance of future gateway util.
    static let `default`: FutureGatewayUtil = FutureGatewayUtil()

    /// Future gateway instance.
    private var futureGateway: FGFutureGateway?

    // MARK: - lifecycle

    private init() {
        // empty
    }

    // MARK: - public methods

    func getFutureGateway() -> FGFutureGateway? {
        return futureGateway
    }

    @discardableResult
    func initializeFutureGateway(username: String?, provider: FGAccessTokenProvider?) -> Bool {
        guard
            let url = URL(string: Constants.FutureGatewayUrl),
            let provider = provider,
            let username = username
        else {
            print("Future gateway initialization failed")
            return false
        }

        self.futureGateway = FGFutureGateway(url: url, username: username, provider: provider)

        print("Future gateway is initialized \(self.futureGateway!)")

        return true
    }

}
