//
//  Constant.swift
//  Flaintartist
//
//  Created by Kerby Jean on 1/1/17.
//  Copyright © 2017 Kerby Jean. All rights reserved.
//


import MapKit
import SwiftyUserDefaults


// UserDefault
extension DefaultsKeys {
    static let key_uid = DefaultsKey<String?>("uid")
    static let name = DefaultsKey<String>("name")
}


//Queue
let queue = DispatchQueue(label: "com.flaint.data")

//UID
let userID = Defaults[.key_uid]
