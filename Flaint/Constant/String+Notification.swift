//
//  String+Notification.swift
//  Flaint
//
//  Created by Kerby Jean on 4/26/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    static let rotationStarted = NSNotification.Name("rotationStarted")
    static let rotationChanged = NSNotification.Name("rotationChanged")
    static let rotationEnded = NSNotification.Name("rotationEnded")
    static let recenterRotation = NSNotification.Name("recenterRotation")

}
