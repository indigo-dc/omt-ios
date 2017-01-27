//
//  LoginViewController.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01/13/2017.
//  Copyright (c) 2017 Sebastian Mamczak. All rights reserved.
//

import UIKit
import AppAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIDesignHelper.updateUI(navigationController?.navigationBar)
        UIDesignHelper.updateUI(loginButton)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        // begin authorization
        AuthUtil.default.beginAuthorizationFlow() { authState, error in
            
            guard error == nil else {
                
                // show error
                UIHelper.showError(error!.localizedDescription)
                
                return
            }
            
            
            
            AuthUtil.default.fetchUserInfo(authState!) { userInfo, error in
                
                
                print("User is fetched")
                
            }
            
        }
    }
    
}
