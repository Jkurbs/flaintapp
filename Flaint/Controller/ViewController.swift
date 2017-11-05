//
//  ViewController.swift
//  Flaint
//
//  Created by Kerby Jean on 2017-07-04.
//  Copyright © 2017 Flaint, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    struct Panel {
        var titles = ["A Peek In the Abstract World", "Best in the Modern World?" ,"Time to be realistic"]
        var thumbnails = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three")]
    }
    
    
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageVIew: RoundImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var pageControl: FlexiblePageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupViews()
        addGestures()
    }
    
    
    //MARK: - CollectionView Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let panel = Panel()
        let title = panel.titles[indexPath.row]
        let thumbnail = panel.thumbnails[indexPath.row]
        cell.headerLabel.text = title
        cell.imageView.image = thumbnail
        if indexPath.row == 1 {
            cell.headerLabel.font = UIFont.boldSystemFont(ofSize: 35)
            cell.topConstraint.constant = 50
            cell.heightContraint.constant = 200
        } else if indexPath.row == 2 {
            cell.headerLabel.textAlignment = .center
        }
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var type = "Abstract"
        if indexPath.row == 1 {
            type = "Modern"
        } else if indexPath.row == 2 {
            type = "Realism"
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowcaseVC") as! ShowcaseVC
        vc.type = type
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
    
    
    // MARK: - SETUPS
    
    func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupViews() {
        
        DataService.instance.currentUserInfo { (user) in
            if let url = user?.profilePicUrl {
                self.profileImageVIew.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .continueInBackground, completed: { (image, error, cache, url) in
                })
            }
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateFormat = "EEEE, MMMM yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        
        pageControl = FlexiblePageControl(frame: bottomView.bounds)
        pageControl.isUserInteractionEnabled = true
        pageControl.dotSize = 6
        pageControl.dotSpace = 5
        pageControl.hidesForSinglePage = true
        pageControl.displayCount = 5
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.flatGrayColorDark()
        pageControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomView.addSubview(pageControl)
        pageControl.numberOfPages = 3
        pageControl.updateViewSize()
    }
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gestures
    
    @objc func profileImageTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsNav") 
        self.present(vc!, animated: true, completion: nil)
    }
}

