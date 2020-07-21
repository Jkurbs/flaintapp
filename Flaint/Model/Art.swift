//
//  Art.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

struct Art: Codable {
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
    
    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        return title.lowercased().contains(lowercasedFilter)
    }
}

extension Art: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Art, rhs: Art) -> Bool {
        lhs.id != rhs.id
    }
}
