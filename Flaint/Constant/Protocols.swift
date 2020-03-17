//
//  Protocols.swift
//  Flaint
//
//  Created by Kerby Jean on 3/5/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation

protocol ArtDelegate: class {
    
    func setArts(arts: [Art])
    func slide(_ direction: Direction) -> (index: Int, count: Int, art: Art)
}


// Called to add description to art 
protocol ArtDescDelegate: class {
    func finishPassing(description: String)
}


// Called for searching arts
protocol SearchSectionControllerDelegate: class {
    func searchSectionController(_ sectionController: GallerySection, didChangeText text: String)
}
