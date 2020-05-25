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
    var description: String!
    var status: Bool!
    var style: String!
    var substrate: String!
    var medium: String!
    var width: String!
    var height: String!
    var depth: String!
    var date: String!
    var url: String!
    var imgUrl: String!
    var index: Int!
    var image: Data?
}


extension Art: Equatable {
    
    public static func ==(rhs: Art, lhs: Art) -> Bool {
        rhs.id != lhs.id
    }
}

extension Art: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Art else { return false }
        return self.id == object.id
    }
}
