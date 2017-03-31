//
//  UIDesignHelper.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 18.01.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class UIDesignHelper {

    // MARK: - colors

    static let AccentColorFg1       = makeColor(r: 255, g: 255, b: 255)
    static let AccentColorBg1       = makeColor(r: 0, g: 0, b: 216)

    static let AccentColorFg2       = makeColor(r: 255, g: 255, b: 255)
    static let AccentColorBg2       = makeColor(r: 216, g: 0, b: 216)

    // MARK: - public methods

    public static func updateUI(_ app: UIApplication, window: UIWindow?) {
        app.statusBarStyle = UIStatusBarStyle.lightContent
        window?.tintColor = UIDesignHelper.AccentColorBg2
    }

    public static func updateUI(_ navigationBar: UINavigationBar?) {
        navigationBar?.barTintColor = UIDesignHelper.AccentColorBg1
        navigationBar?.tintColor = UIDesignHelper.AccentColorFg1
        navigationBar?.titleTextAttributes = [
            NSForegroundColorAttributeName: UIDesignHelper.AccentColorFg1
        ]
    }

    public static func updateUI(_ button: UIButton?) {
        button?.backgroundColor = UIDesignHelper.AccentColorBg2
        button?.tintColor = UIDesignHelper.AccentColorFg2
    }

    // MARK: - private methods

    private static func makeColor(r: Int, g: Int, b: Int) -> UIColor {
        let newRed = CGFloat(r)/255
        let newGreen = CGFloat(g)/255
        let newBlue = CGFloat(b)/255
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }

}
