//
//  User.swift
//  Flaint
//
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Users: Codable {
    var userId: String!
    var name: String!
    var username: String?
    var email: String?
    var phone: String?
    var imgUrl: String?
}

extension Users: Equatable {
    
    static public func ==(rhs: Users, lhs: Users) -> Bool {
        return  rhs.userId == lhs.userId
    }
}

extension Users: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return userId as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Users else { return false }
        return self.userId == object.userId
    }
}

