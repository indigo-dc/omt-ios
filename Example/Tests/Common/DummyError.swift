//
//  DummyError.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 06.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct DummyError: Error {
    
    var msg: String
    
    var localizedDescription: String {
        return msg
    }
    
}
