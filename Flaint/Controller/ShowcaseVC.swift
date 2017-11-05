//
//  ShowcaseVC.swift
//  Flaint
//
//  Created by Kerby Jean on 2017-07-10.
//  Copyright © 2017 Flaint, Inc. All rights reserved.
//

import UIKit
import Firebase

class ShowcaseVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    var arts = [Art]()
    var art: Art?
    var user: Users?
    var userUid: String?
    var type = ""
    
    var pageControl: FlexiblePageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        loadArts()
        setupViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true 
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: - Load Arts
    
    func loadArts() {
        let ref =  DataService.instance.REF_ARTS
        ref.queryOrdered(byChild: "type").queryEqual(toValue: type).queryLimited(toLast: 10).observe(.value, with: {[weak self] (snapshot) in
            self?.arts = []
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let art = Art(key: key, artData: postDict)
                        self?.art = Art(key: key, artData: postDict)
                        self?.arts.insert(art, at: 0)
                    }
                }
            }
            
            
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0, animations: {
                    //self?.progressView.setProgress(1.0, animated: true)
                }, completion: {(true) in
                    UIView.animate(withDuration: 3.0, animations: {
                        //self?.progressView.alpha = 0.0
                        //self?.bottomLine.alpha = 1.0
                    })
                })
                
                //self?.messageBtn.setBadge(text: "1")
                self?.collectionView.reloadData()
                self?.pageControl.numberOfPages = (self?.arts.count)!
            }
            }, withCancel: nil)
        
        
        DataService.instance.REF_NEW.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let art = Art(key: key, artData: postDict)
                        self.art = Art(key: key, artData: postDict)
                        self.arts.insert(art, at: 0)
                    }
                }
            }
        })
        
        ref.observe(.childRemoved, with: { (snapshot) in
            DataService.instance.REF_NEW.observe(.childRemoved, with: { (snapshot) in
            })
            DispatchQueue.main.async {
                //self.collectionView.reloadData()
            }
        }, withCancel: nil)
      }
    
    
    // MARK: - CollectionView Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let art = arts[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseCell", for: indexPath) as? ShowcaseCell {
            cell.showcaseScene.boxnode.removeFromParentNode()
            cell.configureCell(forArt: art)
            DataService.instance.REF_USERS.child(art.userUid).observe(.value) { (snapshot: DataSnapshot) in
                if  let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    self.user = Users(key: key,artistData: postDict)
                    self.profileImageView.sd_setImage(with: URL(string: (self.user?.profilePicUrl ?? "")))
                    self.nameLabel.text = "\(self.user?.name ?? "")"
                }
            }
          return cell
        } else {
            return ShowcaseCell()
        }
    }
    
    
    // MARK: - Setups Delegates
    
    func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Setups Views
    
    func setupViews() {
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
        pageControl.updateViewSize()
    }

}
