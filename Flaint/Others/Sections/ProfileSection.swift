//
//  ProfileSection.swift
//  Flaint
//
//  Created by Kerby Jean on 4/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit

class ProfileSection: ListSectionController {
    
    private var status: Int?
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width

        if index == 0 {
            return CGSize(width: width, height: 100)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let detailsCell = collectionContext?.dequeueReusableCell(of: DetailsCell.self, for: self, at: index) as? DetailsCell else {
            fatalError()
        }
        
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ProfileImageCell.self, for: self, at: index) as? ProfileImageCell else {
                fatalError()
            }
            
            cell.imageView.image = UIImage(named: "img")
            return cell
        } else {
            detailsCell.label.text = "Sarah Jean"
            detailsCell.quoteLabel.text = "＂Beauty will save the world＂"
            detailsCell.artCountLabel.text = "Art: 10"

            return detailsCell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.status = object as? Int
    }
}
