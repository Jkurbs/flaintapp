//
//  ArtSection.swift
//  Flaint
//
//  Created by Kerby Jean on 5/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit


class SearchArtSection: ListSectionController, ListScrollDelegate {
    
    weak var delegate: SearchSectionControllerDelegate?
    
    private var art: Art?
    
    override func sizeForItem(at index: Int) -> CGSize {
       
        let width = collectionContext!.containerSize.width
        let infoHeight:CGFloat = 150
        
        if index == 0 {
            return CGSize(width: width, height: 430)
        } else {
            return CGSize(width: width, height: infoHeight)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        scrollDelegate = self
    }
    
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ProfileArtCell.self, for: self, at: index) as? ProfileArtCell else {
                fatalError()
            }
            cell.art = self.art
            cell.artRoomScene.boxnode.removeFromParentNode()
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: ProfileArtInfoCell.self, for: self, at: index) as? ProfileArtInfoCell else {
                fatalError()
            }
            cell.configure(art!)
            cell.learnMoreButton.addTarget(self, action: #selector(learnMore), for: .touchUpInside)
            cell.learnMoreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(learnMore)))
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        self.art = object as? Art
    }
    
    @objc func learnMore() {
        let vc = LearnMoreVC()
        if let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? ProfileArtCell {
            vc.artImg = cell.artImg
            vc.art = self.art
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchArtSection {
    
    func listAdapter(_ listAdapter: ListAdapter, didScroll sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willBeginDragging sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDragging sectionController: ListSectionController, willDecelerate decelerate: Bool) {
        
    }
}


