//
//  FileHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 02.04.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class FileHelper {
    
    public static func pathToFile(_ filename: String) -> URL? {
        if let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = docPath.appendingPathComponent(filename)
            return filePath
        }
        return nil
    }
    
    public static func createFile(_ filename: String) {
        if let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = docPath.appendingPathComponent(filename)
            let data = "test".data(using: .utf8)
            try? data?.write(to: filePath)
        }
    }
    
    public static func deleteFile(_ filename: String) {
        if let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = docPath.appendingPathComponent(filename)
            try? FileManager.default.removeItem(at: filePath)
        }
    }
    
}
