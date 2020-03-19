//
//  Profile+Data.swift
//  Flaint
//
//  Created by Kerby Jean on 9/9/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

extension ProfileVC {

    // Fetch user current arts 
    @objc func fetchArts() {
        var arts = [Art]()
        DataService.shared.fetchCurrentUserArt { result in
            if let art = try? result.get() as? Art {
                DispatchQueue.main.async {
                    arts.append(art)
                    if arts.count == 1 {
                        self.toolbarItems?[1].isEnabled = false
                        self.toolbarItems?[5].isEnabled = false
                    } else {
                        self.toolbarItems?[1].isEnabled = true
                        self.toolbarItems?[5].isEnabled = true
                    }
                    self.countLabel.text = "1 of \(arts.count)"
                    self.adapter.performUpdates(animated: true, completion: { (done) in
                        self.currentArt = arts.first
                        self.delegate?.fetchArts(arts: arts)
                    })
                }
            }
        }
    }
}
