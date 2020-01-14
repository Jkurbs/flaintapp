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
            NotificationCenter.default.post(name: Notification.Name("slide"), object: nil, userInfo: ["direction": "Left"])
        case 1:
           NotificationCenter.default.post(name: Notification.Name("slide"), object: nil, userInfo: ["direction": "Right"])
        case 2:
            // Share art
            let shareVC = ShareVC()
            shareVC.art = self.art ?? self.arts.first
            shareVC.artImg = self.artImg
            let nav = UINavigationController(rootViewController: shareVC)
            self.navigationController?.present(nav, animated: true, completion: nil)
        case 3:
           // More options
           more()
        default:
            print("default")
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

//    @objc func more() {
//
//        guard let art = self.art, let artId = art.id else {return}
//
//        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
//
//        let recordAction = UIAlertAction(title: "Record", style: .default) { (action) in
//            self.startRecording()
//        }
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
//            let vc = EditArtVC()
//            vc.viewController = self
//            vc.artImg = self.artImg
//            vc.art = art
//            let nav = UINavigationController(rootViewController: vc)
//            self.navigationController?.present(nav, animated: true, completion: nil)
//        }
//
//        _ = UIAlertAction(title: "Share", style: .default) { (action) in
//            let activityViewController = UIActivityViewController(activityItems: ["test" as NSString], applicationActivities: nil)
//            self.present(activityViewController, animated: true, completion: nil)
//        }
//        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
//            let deleteAlert = UIAlertController(title: "Are you sure you want to delete it from your gallery?", message: nil, preferredStyle: .actionSheet)
//            let yesAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
//                // Delete art
//
//                DataService.shared.deleteArt(userId: Auth.auth().currentUser!.uid, artId: artId, { (success, error) in
//                        if !success {
//                            // Show error message
//                            self.showMessage("Error while deleting", type: .error)
//                        } else {
//                            // Show success message
//                            if self.arts.count == 0 {
//                                self.adapter.reloadData(completion: nil)
//                                self.arts.removeAll()
//                            }
//                            self.adapter.performUpdates(animated: true, completion: { (done) in
//                                self.fetchArts()
//                                self.showMessage("Successfully deleted", type: .success)
//                            })
//                        }
//                    })
//                })
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            deleteAlert.addAction(yesAction)
//            deleteAlert.addAction(cancelAction)
//            self.present(deleteAlert, animated: true, completion: nil)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addAction(recordAction)
//        alert.addAction(editAction)
////        alert.addAction(shareAction)
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//    }

    @objc func options() {
        let vc = SettingsVC()
        vc.userId = self.userUID
        vc.navigationController?.isToolbarHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func changeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewVC = storyboard.instantiateViewController(identifier: "ViewVC") as! ViewVC
        let nav = UINavigationController(rootViewController: viewVC)
        nav.modalPresentationStyle = .fullScreen
        nav.isToolbarHidden = false

        UIView.animate(withDuration: 0.2, animations: {
            self.rotateButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (action) in
            if (ARConfiguration.isSupported) {
                nav.hero.isEnabled = true
                nav.hero.modalAnimationType = .fade
                self.rotateButton.transform = .identity
                self.navigationController?.present(nav, animated: true, completion: nil)
            } else {

            }
        }
    } 


    @objc func add() {
        let vc = AddImageVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}
