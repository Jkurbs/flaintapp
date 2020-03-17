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
    
    @objc func more() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            let editVC = EditArtVC()
            editVC.art = self.art
            let nav = UINavigationController(rootViewController: editVC)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
        
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            // Delete art
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func options() {
        let vc = SettingsVC()
        vc.userId = self.userUID
        vc.navigationController?.isToolbarHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func add() {
        let vc = AddImageVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
