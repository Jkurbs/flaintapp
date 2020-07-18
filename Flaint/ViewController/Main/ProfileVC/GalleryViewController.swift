//
//  GalleryViewController.swift
//  Flaint
//
//  Created by Kerby Jean on 4/20/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

/* Abstract:
 View controller for displaying user arts
 */



import UIKit
import FirebaseAuth

class GalleryViewController: UIViewController {
    
    // MARK: - UI Elements
    
    var collectionView: UICollectionView!
    var adjustView = AdjustView()
    var orientationView = OrientationView()
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    // MARK: - Properties
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case image, info
        
        var description: String {
            switch self {
            case .image: return "image"
            case .info: return "info"
            }
        }
    }
    
    var arts = [Art]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Art>!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavItem()
        configureToolItem()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArts()
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
}

extension GalleryViewController {
    
    @objc func fetchArts() {
        self.arts = []
        DataService.shared.fetchCurrentUserArt(userId: Auth.auth().currentUser!.uid) { [weak self] result in
            guard let self = self else { return }
            if let art = try? result.get() as? Art {
                self.arts.append(art)
                DispatchQueue.main.async {
                    self.orientationView.label.text = "1 of \(self.arts.count)"
                    self.applyInitialSnapshots()
                }
            }
        }
    }
    
    func configureNavItem() {
        
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
        
        let cropImageConfiguration = UIImage.SymbolConfiguration(pointSize: 19, weight: .regular, scale: .medium)
        let cropButtonImage = UIImage(systemName: "square.on.square", withConfiguration: cropImageConfiguration)!
        
        let reorderButton = UIBarButtonItem(image: cropButtonImage, style: .done, target: self, action: #selector(gotToReorderVC))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotToAddArtVC))
        let menuButton = UIBarButtonItem(image: UIImage(named: "New-menu-filled-20"), style: .plain, target: self, action: #selector(gotToSettingsVC))
        
        let leftBarButtonItems = [reorderButton, searchButton]
        let rightBarButtonItems = [menuButton, addButton]
        navigationItem.leftBarButtonItems = leftBarButtonItems
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    func configureToolItem() {
        // Toolbar setup
        var items = [UIBarButtonItem]()
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Left-30"), style: .done, target: self, action: #selector(test))
        leftButton.isEnabled = false
        leftButton.tag = 0
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "Right-30"), style: .done, target: self, action: #selector(test))
        rightButton.tag = 1
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "More-30"), style: .done, target: self, action: #selector(test))
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
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 100), collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.id)
        collectionView.register(TestView.self, forSupplementaryViewOfKind: "test", withReuseIdentifier: "test")
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            // orthogonal scrolling section of images
            if sectionKind == .image {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .fractionalHeight(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width), heightDimension: .absolute(self.view.frame.height))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                // info
            } else if sectionKind == .info {
                section = NSCollectionLayoutSection.list(using: .init(appearance: .sidebar), layoutEnvironment: layoutEnvironment)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            } else {
                fatalError("Unknown section!")
            }
            
            return section
        }
        return  UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    
    func configureDataSource() {
        // data source
        
        dataSource = UICollectionViewDiffableDataSource<Section, Art>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: self.configuredGridCell(), for: indexPath, item: item)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: self.configuredListCell(), for: indexPath, item: item)
            }
        }
    }
    
    
    func configuredGridCell() -> UICollectionView.CellRegistration<GalleryCell, Art> {
        return UICollectionView.CellRegistration<GalleryCell, Art> { (cell, indexPath, item) in
            cell.art = item
        }
    }
    
    func configuredListCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Art> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Art> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.valueCell()
            content.text = item.title
            content.secondaryText = String(describing: item.description)
            cell.contentConfiguration = content
        }
    }
    
    
    func applyInitialSnapshots() {
        
        // set the order for our sections
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Art>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // recents (orthogonal scroller)
        
        var imageSnapshot = NSDiffableDataSourceSectionSnapshot<Art>()
        imageSnapshot.append(self.arts)
        
        dataSource.apply(imageSnapshot, to: .image, animatingDifferences: false)

        var allSnapshot = NSDiffableDataSourceSectionSnapshot<Art>()
        allSnapshot.append(self.arts)
        dataSource.apply(allSnapshot, to: .info, animatingDifferences: false)
    }
    
    
    @objc func test() {
        
    }
}

class TestView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
