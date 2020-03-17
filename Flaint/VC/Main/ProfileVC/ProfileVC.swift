//
//  ProfileVC.swift
//  Flaint
//
//  Created by Kerby Jean on 4/20/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

/* Abstract:
 View controller for displaying user profile
 */

import UIKit
import ARKit
import IGListKit
import ReplayKit
import Cartography
import GSMessages
import SwiftKeychainWrapper


class ProfileVC: UIViewController, ListAdapterDataSource, RPPreviewViewControllerDelegate {
    
    // MARK: - UI Elements
    
    lazy var countLabel = CountLabel()
    
    var addButton: UIBarButtonItem!
    var menuButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    
    var leftButton: UIBarButtonItem!
    var rightButton: UIBarButtonItem!
    
    var rotateButton: UIButton!
    
    // MARK: - Properties
    
    var userUID: String?
    var art: Art?
    var artImg: UIImage!
    var arts = [Art]()
    
    weak var delegate: ArtDelegate? 
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArts()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewHeight = self.view.bounds.height
        
        self.countLabel.frame = CGRect(x: self.view.bounds.width - 45, y: 0, width: 32, height: 20)
        self.countLabel.layer.cornerRadius = 10
        countLabel.frame = CGRect(x: 0, y: viewHeight - 120, width: view.frame.width, height: 25)
    }
    
    
    // MARK: - Functions
    
    func setupViews() {
        
        searchBar.barStyle = .default
        searchBar.placeholder = "Search gallery"
        searchBar.isTranslucent = true
        searchBar.barTintColor = .backgroundColor
        searchBar.returnKeyType = .done
                
        view.backgroundColor = .backgroundColor
        
        view.addSubview(countLabel)
        
        // NavBar setup
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action:  #selector(options))
        
        navigationItem.rightBarButtonItems = [menuButton, addButton, searchButton]
        
        // Toolbar setup
        var items = [UIBarButtonItem]()
        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
                
        leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle", withConfiguration: symbolConfig), style: .done, target: self, action: #selector(action(_:)))
        leftButton.isEnabled = false
        leftButton.tag = 0
        
        rightButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right.circle", withConfiguration: symbolConfig), style: .done, target: self, action: #selector(action(_:)))
        rightButton.tag = 1
        
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle", withConfiguration: symbolConfig), style: .done, target: self, action: #selector(more))
        moreButton.tag = 3
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(leftButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(moreButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(rightButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        self.navigationController?.toolbar.barTintColor = .backgroundColor
        self.toolbarItems = items
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.backgroundColor = .backgroundColor
        
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.view.addSubview(countLabel)
    }    
}

