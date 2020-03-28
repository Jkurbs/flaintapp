//
//  StatusBar.swift
//  Flaint
//
//  Created by Kerby Jean on 8/29/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import UIKit

// gives control of the status bar appearance to the top controller
extension UINavigationController {
    override open var childForStatusBarHidden: UIViewController? {
        self.topViewController
    }
}
