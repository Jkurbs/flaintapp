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
    
    @objc func gotToReorderVC() {
        let vc = ReorderVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.arts = self.arts
        vc.navigationController?.isToolbarHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
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
        self.searchBar.text = nil
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = nil
        //        self.navigationItem.rightBarButtonItems = [menuButton, addButton, searchButton]
        self.adapter.performUpdates(animated: false, completion: nil)
    }
    
    @objc func action(_ button: UIBarButtonItem) {
        switch button.tag {
        case 0:
            slide(.left)
        case 1:
            slide(.right)
        case 2:
            more()
        default:
            break
        }
    }
    
    func slide(_ direction: Direction) {
        let result = delegate?.slide(direction)
        countLabel.result = result
    }
    
    @objc func more() {
        
        guard let art = self.currentArt else { return }
        
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { _ in
            DispatchQueue.main.async {
                let editVC = EditArtVC()
                editVC.art = art
                let nav = UINavigationController(rootViewController: editVC)
                nav.modalPresentationStyle = .fullScreen
                self.navigationController?.present(nav, animated: true, completion: nil)
            }
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
            let confirmationAlert = UIAlertController(title: "Are you sure you want to delete it from your gallery?", message: nil, preferredStyle: .actionSheet)
            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                guard  let userId = AuthService.shared.UserID, let id = art.id, let title = art.title, let style = art.style else { return }
                self.delegate?.removeArt(art, { (done) in
                    if done {
                        DataService.shared.deleteArt(userId: userId, artId: id, artStyle: style) { _ in
                            DispatchQueue.main.async {
                                self.showMessage("\(title) successfully deleted", type: .error)
                            }
                        }
                    }
                })
            }))
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(confirmationAlert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func gotToSettingsVC() {
        let vc = SettingsVC()
        vc.userId = self.userUID
        vc.navigationController?.isToolbarHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func gotToAddArtVC() {
        DispatchQueue.main.async {
            let vc = AddImageVC()
            
            vc.artsCount = self.countLabel.result?.count
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
}
