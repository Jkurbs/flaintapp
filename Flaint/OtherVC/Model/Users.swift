//
//  User.swift
//  Flaint
//
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Users {
    
    var userId: String!
    var name: String!
    var username: String?
    var email: String?
    var phone: String?
    var imgUrl: String? 
    
    init(key: String? , data: [String: Any]?) {
        
        if let key = key, let data = data {
            self.userId = key
            if let name = data["name"] as? String {self.name = name}
            if let username = data["username"] as? String {self.username = username}
            if let email = data["email"] as? String {self.email = email}
            if let phone = data["phone"] as? String {self.phone = phone}
            if let imgUrl = data["imgUrl"] as? String {self.imgUrl = imgUrl}
        }
    }
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

