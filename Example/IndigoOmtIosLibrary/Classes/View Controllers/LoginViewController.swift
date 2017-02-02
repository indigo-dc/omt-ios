//
//  LoginViewController.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01/13/2017.
//  Copyright (c) 2017 Sebastian Mamczak. All rights reserved.
//

import UIKit

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
        AuthUtil.default.beginAuthorizationFlow() { provider, error in
            
            guard error == nil else {
                
                // show error
                UIHelper.showError(error!.localizedDescription)
                
                return
            }
            
            // initialize future gateway
            let fgu = FutureGatewayUtil.default
            if fgu.initializeFutureGateway(provider) {
                print("Future gateway is initialized \(fgu.getFutureGateway()!)")
            }
            else {
                print("Future gateway initialization failed")
            }
            
            // load main view controller
            let mainViewController = UIHelper.loadViewController("MainViewController")
            mainViewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(mainViewController, animated: true)
            
            // fetch user info
            self.fetchUserInfo()
        }
    }
    
    private func fetchUserInfo() {
        DispatchQueue.global().async {
            
            AuthUtil.default.fetchUserInfo { userInfo, error in
                
                if userInfo != nil {
                    print("User is fetched \(userInfo!)")
                }
            }
        }
    }
    
}
