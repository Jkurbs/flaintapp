//
//  Profile + IGListKit.swift
//  Flaint
//
//  Created by Kerby Jean on 9/3/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import IGListKit


extension ProfileVC {
    
    // MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [1] as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = GallerySection()
        self.delegate = section
        return section
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
