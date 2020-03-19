//
//  Art.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Art: Codable {
    
    var id: String!
    let title: String!
    var price: String!
    var sentiment: String!
    var description: String!
    var style: String!
    var substrate: String!
    var medium: String!
    var width: String!
    var height: String!
    var depth: String!
    var date: String!
    var url: String!
    var imgUrl: String!
    var image: Data?
}


extension Art: Equatable {
    
    static public func ==(rhs: Art, lhs: Art) -> Bool {
        return rhs.id != lhs.id
    }
}

extension Art: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Art else { return false }
        return self.id == object.id
    }
}
