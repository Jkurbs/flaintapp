//
//  Profile+Data.swift
//  Flaint
//
//  Created by Kerby Jean on 9/9/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

extension ProfileVC {
    
    // Fetch user current arts
    @objc func fetchArts() {
        self.arts.removeAll()
        DataService.shared.fetchCurrentUserArt(userId: userUID ?? Auth.auth().currentUser?.uid) { result in
            if let art = try? result.get() as? Art {
                DispatchQueue.main.async {
                    self.arts.append(art)
                    self.showHideUI()
                    self.arts = self.arts.sorted { $0.index < $1.index }
                    self.orientationView.label.text = "1 of \(self.arts.count)"
                    self.currentArt = self.arts.first
                    self.delegate?.fetchArts(arts: self.arts)
                }
            }
        }
    }
    
    func showHideUI() {
        switch self.arts.count {
        case 0:
            self.navigationItem.leftBarButtonItems = nil
        case 1:
            self.navigationController?.setToolbarHidden(false, animated: false)
            self.toolbarItems?[1].isEnabled = false
            self.toolbarItems?[5].isEnabled = false
        default:
            self.toolbarItems?[1].isEnabled = false
            self.toolbarItems?[5].isEnabled = true
        }
    }
}
