//
//  MainViewController.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 18.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare
        UIDesignHelper.updateUI(navigationController?.navigationBar)
    }

}
