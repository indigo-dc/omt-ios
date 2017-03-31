//
//  FGAbstractApi.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation

/// Abstract class for any API implementation.
open class FGAbstractApi {

    // MARK: - properties

    /// Request helper.
    public let helper: FGRequestHelper

    // MARK: - lifecycle

    public init(helper: FGRequestHelper) {
        self.helper = helper
    }

}
