//
//  Art.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class Art {
    
    var id: String!
    var title: String!
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
    

    init(key: String, data: Dictionary<String, AnyObject>) {

        self.id = key
    
        if let title = data["title"] as? String {
            self.title = title
        }
        
        if let price = data["price"] as? String {
            self.price = price
        }
        
        if let sentiment = data["sentiment"] as? String {
            self.sentiment = sentiment
        }

        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let style = data["style"] as? String  {
            self.style = style
        }
        
        if let substrate = data["substrate"] as? String  {
            self.substrate = substrate
        }
        
        if let medium = data["medium"] as? String  {
            self.medium = medium
        }
        
        if let width = data["width"] as? String {
            self.width = width
        }
        
        if let height = data["height"] as? String {
            self.height = height
        }
        
        if let depth = data["depth"] as? String {
            self.depth = depth
        }
        
        if let date = data["date"] as? String {
            self.date = date
        }
        
        if let url = data["url"] as? String {
            self.url = url
        }
        
        if let imgUrl = data["imgUrl"] as? String {
           self.imgUrl = imgUrl
        }
    }
}


extension Art: Equatable {
    
    static public func ==(rhs: Art, lhs: Art) -> Bool {
        return  rhs.id == lhs.id
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
