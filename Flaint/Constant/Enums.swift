//
//  Enums.swift
//  Flaint
//
//  Created by Kerby Jean on 3/5/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation



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
enum Direction {
    case left
    case right
}
