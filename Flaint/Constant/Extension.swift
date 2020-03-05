//
//  Extension.swift
//  Flaint
//
//  Created by Kerby Jean on 3/5/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseDatabase


// Return UITableViewCell Id

extension UITableViewCell {
    static var id: String {
        return String(describing: self)
    }
}

// Return UICollectionViewCell Id

extension UICollectionViewCell {
    static var id: String {
        return String(describing: self)
    }
}

// Turn DataSnapshot into JsonData

extension DataSnapshot {
    var data: Data? {
        guard let value = value else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? {
        return data?.string
    }
}

extension Data {
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}
