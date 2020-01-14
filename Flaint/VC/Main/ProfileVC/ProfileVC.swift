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
    
    var recordView = RecorderView()
    var countLabel = CountLabel()

    var addButton: UIBarButtonItem!
    var menuButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    
    var leftButton: UIBarButtonItem!
    var rightButton: UIBarButtonItem!

    var rotateButton: UIButton!

    var userUID: String?
    var user = [Users]()
    var art: Art?
    var artImg: UIImage!
    var arts = [Art]()
        
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArts()
        self.navigationController?.isToolbarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.getImg(_:)), name: NSNotification.Name(rawValue: "count"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("fetchArts"), object: nil, userInfo: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeView), name: NSNotification.Name(rawValue: "ViewVC"), object: nil)
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


    func setupViews() {
        
        searchBar.barStyle = .default
        searchBar.placeholder = "Search gallery"
        searchBar.isTranslucent = true
        searchBar.barTintColor = .backgroundColor
        searchBar.returnKeyType = .done

        UserDefaults.standard.set(true, forKey: "first_time")

        self.hero.isEnabled = true

        view.backgroundColor = .backgroundColor

        view.addSubview(countLabel)
        
        self.recordView.viewController = self
        self.recordView.frame = CGRect(x: 0, y: 0, width: 190, height: 60)
    
        
        // NavBar setup
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action:  #selector(options))

        navigationItem.rightBarButtonItems = [menuButton, addButton, searchButton]
        
        // Toolbar setup
        var items = [UIBarButtonItem]()

        self.rotateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.rotateButton.setImage(UIImage(named: "Rotation-30"), for: UIControl.State())
        self.rotateButton.addTarget(self, action: #selector(changeView), for: .touchUpInside)
        let rotateButton = UIBarButtonItem(customView: self.rotateButton)

        
        leftButton = UIBarButtonItem(image: UIImage(named: "Left-30"), style: .done, target: self, action: #selector(action(_:)))
        leftButton.tag = 0
        leftButton.isEnabled = false
        
        rightButton = UIBarButtonItem(image: UIImage(named: "Right-30"), style: .done, target: self, action: #selector(action(_:)))
        rightButton.tag = 1
        
        let shareButton = UIBarButtonItem(image: UIImage(named: "Share-30"), style: .done, target: self, action: #selector(action(_:)))
        shareButton.tag = 2
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "More-30"), style: .done, target: self, action: #selector(action(_:)))
        moreButton.tag = 3
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(leftButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(shareButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(rotateButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(moreButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(rightButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))

        self.navigationController?.toolbar.barTintColor = .backgroundColor
        self.toolbarItems = items

        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.backgroundColor = .backgroundColor

        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        self.view.addSubview(countLabel)
    }    
}

