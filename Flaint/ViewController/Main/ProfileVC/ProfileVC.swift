//
//  ProfileVC.swift
//  Flaint
//
//  Created by Kerby Jean on 4/20/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

/* Abstract:
 View controller for displaying user arts
 */

import UIKit
import IGListKit
import FirebaseAuth
import SDWebImage

class ProfileVC: UIViewController, ListAdapterDataSource {
    
    // MARK: - UI Elements
    
    var adjustView = AdjustView()
    var orientationView = OrientationView()
    
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
    
    weak var collectionView: UICollectionView?
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func reloadData() {
        self.fetchArts()
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
        NSLayoutConstraint.activate([
            adjustView.heightAnchor.constraint(equalToConstant: 25.0),
            adjustView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: - Functions
    
    func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        adjustView = AdjustView()
        orientationView = OrientationView()
        
        self.navigationItem.titleView = adjustView
        adjustView.autoresizingMask = .flexibleWidth
        
        searchBar.barStyle = .default
        searchBar.placeholder = "Search gallery"
        searchBar.isTranslucent = true
        searchBar.barTintColor = .systemBackground
        searchBar.returnKeyType = .done
        view.backgroundColor = .systemBackground
        
        // NavBar setup
        
        let cropImageConfiguration = UIImage.SymbolConfiguration(pointSize: 19, weight: .regular, scale: .medium)
        let cropButtonImage = UIImage(systemName: "square.on.square", withConfiguration: cropImageConfiguration)!
        
        let reorderButton = UIBarButtonItem(image: cropButtonImage, style: .done, target: self, action: #selector(gotToReorderVC))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotToAddArtVC))
        let menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action: #selector(gotToSettingsVC))
        
        leftBarButtonItems = [reorderButton, searchButton]
        rightBarButtonItems = [menuButton, addButton]
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
        
        self.navigationController?.toolbar.barTintColor = .systemBackground
        self.toolbarItems = items
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView = collectionView
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.view.addSubview(orientationView)
    }
    
    deinit {
        print("DEINIT IS CALLED")
    }
}
