//
//  ArtSection.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseDatabase


class GallerySection: ListSectionController, ListAdapterDataSource, UIScrollViewDelegate, UISearchBarDelegate, SearchSectionControllerDelegate {
    
    // MARK: - Properties
    
    private var status: Int?
    private var expanded = false
    
    var filteredArts: Art!
    var currentIndex = 0
    var filterString = ""
    var searchBar: UISearchBar!
    weak var vc: ProfileVC?
    var arts = [Art]()
    
    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 2)
    }()
    
    weak var delegate: SearchSectionControllerDelegate?
    
    var collectionView: UICollectionView?
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.frame = self.viewController!.view.bounds
        label.textColor = .darkText
        label.backgroundColor = .backgroundColor
        label.textAlignment = .center
        label.numberOfLines = 5
        label.text = "You have no artwork yet! \n Tap on the + button to add your first."
        return label
    }()
    
    // MARK: - Initializer
    
    override func sizeForItem(at index: Int) -> CGSize {
        let guide = self.viewController?.view.safeAreaLayoutGuide
        let height = guide?.layoutFrame.size.height
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: height!)
    }
    
    override init() {
        super.init()
        setup()
    }
    
    // MARK: - Functions
    
    func setup() {
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        self.delegate = self
        vc = self.viewController as? ProfileVC
        searchBar = vc?.searchBar
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// ArtDelegate

extension GallerySection: ArtDelegate {

    func fetchArts(arts: [Art]) {
        self.arts.removeAll()
        self.arts = arts
        self.adapter.performUpdates(animated: true, completion: nil)
        guard arts.isEmpty else {
            self.adapter.reloadObjects(arts)
            return
        }
    }
        
    func removeArt(_ currentArt: Art, _ completion: @escaping (Bool) -> ()) {
        self.adapter.performUpdates(animated: true) { (done) in
            if let index = self.arts.firstIndex(of: currentArt) {
                self.arts.remove(at: index)
                self.adapter.reloadObjects(self.arts)
                completion(true)
            }
        }
    }
    
    func slide(_ direction: Direction) -> (index: Int, count: Int, art: Art) {
        if direction == .right {
            self.adapter.collectionView?.scrollToNextItem()
            self.currentIndex += 1
            self.vc?.toolbarItems?[1].isEnabled = true
            if self.currentIndex == self.arts.count - 1 {
                self.vc?.toolbarItems?[5].isEnabled = false
            }
        } else {
            self.adapter.collectionView?.scrollToPreviousItem()
            currentIndex -= 1
            self.vc?.toolbarItems?[5].isEnabled = true
            if currentIndex == 0 {
                self.vc?.toolbarItems?[1].isEnabled = false
            }
        }
        
        let art = self.arts[currentIndex]
        self.vc?.currentArt = art
        return (index: currentIndex, count: self.arts.count, art: art)
    }
}

// MARK: - UISearchBarDelegate

extension GallerySection {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchSectionController(self, didChangeText: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        delegate?.searchSectionController(self, didChangeText: searchBar.text!)
    }
}

// MARK: - DataSource

extension GallerySection {
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else { fatalError() }
        adapter.collectionView = cell.collectionView
        collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.status = object as? Int
    }
}

// MARK: - ListAdapterDataSource

extension GallerySection {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard filterString != "" else { return arts }
        return arts.filter { $0.title.lowercased().contains(filterString.lowercased()) }.map { $0 as ListDiffable }
    }
    
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        SearchArtSection()
    }
    
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        emptyLabel
    }
    
    func searchSectionController(_ sectionController: GallerySection, didChangeText text: String) {
        self.filterString = text
        self.adapter.performUpdates(animated: true, completion: nil)
    }
}


// MARK: - UICollectionView Scrolling

extension UICollectionView {
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset: CGFloat) {
        guard contentOffset <= self.contentSize.width - self.bounds.size.width else { return }
        guard contentOffset >= 0 else { return }
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
