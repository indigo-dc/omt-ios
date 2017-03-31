//
//  FGUploadPayload.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.02.2017.
//
//

import Foundation

/// Upload payload response callback.
public typealias FGUploadPayloadResponseCallback = (FGApiResponse<FGEmptyObject>) -> Void

/// Upload payload class.
open class FGUploadPayload: FGAbstractPayload {

    /// MARK: - properties

    /// File to upload.
    public var sourceURL: URL?

    /// Filename of uploaded file.
    public var uploadFilename: String?

}
