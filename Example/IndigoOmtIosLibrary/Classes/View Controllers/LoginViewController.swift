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
            
            // fetch user info - needed to create future gatweway object
            self.fetchUserInfo() { userInfo, error in
                
                guard
                    error == nil,
                    userInfo != nil
                else {
                    
                    // show error
                    UIHelper.showError(error!.localizedDescription)
                    
                    return
                }
                
                //let username = userInfo!.preferredUsername
                let username = Constants.tempUsername
                
                // initialize future gateway
                let fgu = FutureGatewayUtil.default
                if fgu.initializeFutureGateway(username: username, provider: provider) {
                    
                    // go to main view controller
                    self.loadMainViewController()
                }
            }
        }
    }
    
    private func fetchUserInfo(callback: @escaping UserInfoApiCallback) {
        DispatchQueue.global().async {
            
            // fetch user info
            AuthUtil.default.fetchUserInfo { userInfo, error in
                
                if userInfo != nil {
                    print("User is fetched \(userInfo!)")
                }
                
                callback(userInfo, error)
            }
        }
    }
    
    private func loadMainViewController() {
        DispatchQueue.main.async {
            let mainViewController = UIHelper.loadViewController("MainViewController")
            mainViewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
}
