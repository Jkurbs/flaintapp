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
    
    lazy var countLabel = CountLabel()
    
    // MARK: - Properties
    
    var userUID: String?
    var currentArt: Art?
    
    weak var delegate: ArtDelegate? 
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
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
        
        self.navigationController?.isToolbarHidden = false
        fetchArts()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            AuthService.shared.UserID = user?.uid
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
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
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action:  #selector(gotToSettingsVC))
        
        navigationItem.rightBarButtonItems = [menuButton, addButton, searchButton]
        
        // Toolbar setup
        var items = [UIBarButtonItem]()
//        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
                
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
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.backgroundColor = .backgroundColor
        
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.view.addSubview(countLabel)
    }    
}

