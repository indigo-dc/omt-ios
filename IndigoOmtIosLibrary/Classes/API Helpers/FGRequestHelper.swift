//
//  FGRequestHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 07.02.2017.
//
//

import Foundation

/// Request helper class.
public protocol FGRequestHelper {

    /// Dispatch queue for background execution.
    func getBackgroundQueue() -> DispatchQueue

    /// Makes remote request and returns response in callback.
    func send<Value: FGObjectSerializable>(_ payload: FGRequestPayload, callback: @escaping FGRequestHelperCallback<Value>)

    /// Makes remote download file request and returns response in callback.
    func downloadFile(_ payload: FGDownloadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>)

    /// Makes remote upload file request and returns response in callback.
    func uploadFile(_ payload: FGUploadPayload, callback: @escaping FGRequestHelperCallback<FGEmptyObject>)
}
