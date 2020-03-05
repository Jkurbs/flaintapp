//
//  Profile+Actions.swift
//  Flaint
//
//  Created by Kerby Jean on 9/3/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import ARKit
import FirebaseAuth


extension ProfileVC {
    
    // Search Art
    @objc func searchTapped() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearch))
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.titleView = searchBar
        self.searchBar.sizeToFit()
        let deadline = DispatchTime.now() + .milliseconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    @objc func cancelSearch() {
        self.searchBar.text = ""
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = [menuButton, addButton, searchButton]
        self.adapter.performUpdates(animated: false, completion: nil)
    }
    
    @objc func startRecording() {
        self.recordView.startRecording {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    @objc func action(_ button: UIBarButtonItem) {
        switch button.tag {
        case 0:
            let result = delegate?.slide(.left)
            countLabel.result = result
        case 1:
            let result = delegate?.slide(.right)
            countLabel.result = result
        default:
            break
        }
    }
    
    
    func more() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            let editVC = EditArtVC()
            editVC.viewController = self
            editVC.art = self.art ?? self.arts.first
            editVC.artImg = self.artImg
            let nav = UINavigationController(rootViewController: editVC)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func options() {
        let vc = SettingsVC()
        vc.userId = self.userUID
        vc.navigationController?.isToolbarHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let viewVC = storyboard.instantiateViewController(identifier: "ViewVC") as! ViewVC
//        let nav = UINavigationController(rootViewController: viewVC)
//        nav.modalPresentationStyle = .fullScreen
//        nav.isToolbarHidden = false
//        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.rotateButton.transform = CGAffineTransform(rotationAngle: .pi)
//        }) { (action) in
//            if (ARConfiguration.isSupported) {
//                nav.hero.isEnabled = true
//                nav.hero.modalAnimationType = .fade
//                self.rotateButton.transform = .identity
//                self.navigationController?.present(nav, animated: true, completion: nil)
//            } else {
//                
//            }
//        }
    } 
    
    
    @objc func add() {
        let vc = AddImageVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
