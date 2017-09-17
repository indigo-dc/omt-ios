//
//  FGFutureGateway.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01.02.2017.
//
//

import Foundation
import XCGLogger

/// Future Gateway entry object.
open class FGFutureGateway: CustomStringConvertible {

    // MARK: - properties

    /// Currently supported API version.
    public let apiVersion: String = "v1.0"

    /// Application collection API.
    public let applicationCollection: FGApplicationCollectionApi

    /// Task API.
    public let taskApi: FGTaskApi

    /// Task collection API.
    public let taskCollectionApi: FGTaskCollectionApi

    /// File API.
    public let fileApi: FGFileApi

    /// Logger instance.
    public let logger: XCGLogger

    /// CustomStringConvertible
    public var description: String {
        return "FGFutureGateway { apiVersion: \(apiVersion) }"
    }

    // MARK: - lifecycle

    public init(url: URL, provider: FGAccessTokenProvider) {
        // logger
        logger = XCGLogger(identifier: "IndigoOmtIosLibrary", includeDefaultDestinations: false)
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "IndigoOmtIosLibrary.system")
        
        // Optionally set some configuration options
        systemDestination.outputLevel = .error
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = false
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        systemDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        logger.add(destination: systemDestination)

        // Create a file log destination
        let file = URL.urlInDocumentsDirectory(with: "IndigoOmtIosLibrary.log").path
        print("Log file: \(file)")
        let fileDestination = FileDestination(writeToFile: file, identifier: "IndigoOmtIosLibrary.file", shouldAppend: true)

        // Optionally set some configuration options
        fileDestination.outputLevel = .error
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = false
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        fileDestination.logQueue = XCGLogger.logQueue

        // Process this destination in the background
        fileDestination.logQueue = XCGLogger.logQueue

        // Add the destination to the logger
        logger.add(destination: fileDestination)
        logger.logAppDetails()

        // create background dispatch queue
        let queue = DispatchQueue(label: "pl.psnc.futuregateway-queue", attributes: .concurrent)

        // create session helpers for authorized and unauthorized access to API
        let unauthSession = FGSessionHelper(queue: queue, provider: nil)
        let authSession   = FGSessionHelper(queue: queue, provider: provider)

        // create request helpers - one for each session helper
        let unauthHelper = FGAlamofireRequestHelper(session: unauthSession)
        unauthHelper.logger = self.logger
        let authHelper   = FGAlamofireRequestHelper(session: authSession)
        authHelper.logger = self.logger

        // create API resolver to get root url with version
        let apiResolver = FGRootApiResolver(baseUrl: url, versionID: self.apiVersion, helper: unauthHelper)

        // create required APIs
        self.applicationCollection  = FGApplicationCollectionApi(resolver: apiResolver, helper: authHelper)
        self.taskApi                = FGTaskApi(resolver: apiResolver, helper: authHelper)
        self.taskCollectionApi      = FGTaskCollectionApi(resolver: apiResolver, helper: authHelper)
        self.fileApi                = FGFileApi(resolver: apiResolver, helper: authHelper)
    }

}
