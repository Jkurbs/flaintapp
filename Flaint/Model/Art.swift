//
//  Art.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

struct Art: Codable, Hashable {
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
    
    private let identifier = UUID()

}
