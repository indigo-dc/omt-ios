//
//  URL+IndigoOmtIosLibrary.swift
//  Pods
//
//  Created by Sebastian Mamczak on 17.09.2017.
//
//

import Foundation

extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}
