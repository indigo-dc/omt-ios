//
//  FGApiResolver.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation

public protocol FGApiResolver {

    /// Base API URL.
    var baseUrl: URL { get }

    /// API version identifier.
    var versionID: String { get }

    /// Resolves API URL for given version.
    /// Returns error when requested version is not available.
    func resolveUrlWithVersion(_ callback: @escaping FGApiResponseCallback<URL>)
}
