//
//  UIHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 17.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {
    
    static func showError(_ message: String?) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            getRootViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    static func getRootViewController() -> UIViewController {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            return rootVC
        }
        
        fatalError("Cannot get root view controller")
    }
    
    static func loadViewController(_ storyboardID: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardID)
    }
    
}
