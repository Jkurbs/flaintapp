//
//  Protocols.swift
//  Flaint
//
//  Created by Kerby Jean on 3/5/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

protocol ArtDelegate {
    func slide(_ direction: Direction) -> (index: Int, count: Int, art: Art)
}
