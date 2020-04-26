//
//  Enums.swift
//  Flaint
//
//  Created by Kerby Jean on 3/5/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

// Art properties
enum ArtProperties: String, CaseIterable {
 
    case style
    case substrate
    case medium

    var values: [String] {
        switch self {
        case .style:
            return ["Realism", "Abstract", "Pop-art", "Surrealism"]
        case .substrate:
            return ["Canvas", "Wood", "Paper", "Metal"]
        case .medium:
            return ["Oil", "Watercolor", "Acrylic"]
        }
    }
}

// Direction of horizontal scrolling
enum Direction {
    case left
    case right
}

// Setting options
enum Settings: String, CaseIterable {
    
    case edit = "Edit account"
    case password = "Password"
    case logOut = "Log Out"
    
    var values: String {
        switch self {
        case .edit:
            return "Edit account"
        case .password:
            return "Password"
        case .logOut:
            return "Log Out"
        }
    }
}
