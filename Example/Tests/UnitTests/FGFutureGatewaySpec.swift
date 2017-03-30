//
//  FGFutureGatewaySpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 06.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import IndigoOmtIosLibrary

class FGFutureGatewaySpec: QuickSpec {
    override func spec() {
        describe("FGFutureGateway") {
            context("init") {
                it("create object") {
                    // prepare
                    let url = URL(string: "http://future-gateway-server.com")!
                    let username = "username"
                    let provider = DummyProvider()
                    
                    // test
                    let fg = FGFutureGateway(url: url, username: username, provider: provider)
                    
                    // verify
                    expect(fg.taskCollectionApi.resolver.baseUrl).to(equal(url))
                    expect(fg.taskCollectionApi.username).to(equal(username))
                    expect(fg.description).toNot(beEmpty())
                }
            }
        }
    }
}
