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
import IGListKit
import FirebaseAuth
import SDWebImage

class ProfileVC: UIViewController, ListAdapterDataSource {
    
    // MARK: - UI Elements
    
    lazy var orientationView = OrientationView()
    
    // MARK: - Properties
    
    var userUID: String?
    var arts = [Art]()
    var currentArt: Art?
    
    var leftBarButtonItems: [UIBarButtonItem]!
    var rightBarButtonItems: [UIBarButtonItem]!
    
    weak var delegate: ArtDelegate?
    
    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewHeight = self.view.bounds.height
        orientationView.frame = CGRect(x: 0, y: viewHeight - 120, width: view.frame.width, height: 46)
    }
    
    // MARK: - Functions
    
    func setupViews() {
        
        searchBar.barStyle = .default
        searchBar.placeholder = "Search gallery"
        searchBar.isTranslucent = true
        searchBar.barTintColor = .backgroundColor
        searchBar.returnKeyType = .done
        view.backgroundColor = .backgroundColor
        
        // NavBar setup
        let reorderButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .done, target: self, action: #selector(gotToReorderVC))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotToAddArtVC))
        let menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action: #selector(gotToSettingsVC))
        
        leftBarButtonItems = [reorderButton]
        rightBarButtonItems = [menuButton, addButton, searchButton]
        navigationItem.leftBarButtonItems = leftBarButtonItems
        navigationItem.rightBarButtonItems = rightBarButtonItems
        
        // Toolbar setup
        var items = [UIBarButtonItem]()
                
        let leftButton = UIBarButtonItem(image: UIImage(named: "Left-30"), style: .done, target: self, action: #selector(action(_:)))
        leftButton.isEnabled = false
        
        leftButton.tag = 0
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "Right-30"), style: .done, target: self, action: #selector(action(_:)))
        rightButton.tag = 1
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "More-30"), style: .done, target: self, action: #selector(more))
        moreButton.tag = 2
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(leftButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(moreButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(rightButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        self.navigationController?.toolbar.barTintColor = .backgroundColor
        self.toolbarItems = items
        self.navigationController?.isToolbarHidden = true
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.view.addSubview(orientationView)
    }
}
