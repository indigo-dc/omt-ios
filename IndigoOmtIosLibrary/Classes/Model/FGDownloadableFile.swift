//
//  FGDownloadableFile.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 27.02.2017.
//
//

import Foundation

/// Downloadable file protocol.
public protocol FGDownloadableFile {
    
    /// Download link.
    var url: String? { get }
    
}
