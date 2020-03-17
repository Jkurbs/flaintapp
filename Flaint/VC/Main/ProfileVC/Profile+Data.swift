//
//  Profile+Data.swift
//  Flaint
//
//  Created by Kerby Jean on 9/9/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

extension ProfileVC {
    
    @objc func fetchArts() {
        var arts = [Art]()
        DataService.shared.fetchCurrentUserArt { result in
            if let art = try? result.get() as? Art {
                DispatchQueue.main.async {
                   arts.append(art)
                   if self.arts.count == 1 {
                       self.leftButton.isEnabled = false
                       self.rightButton.isEnabled = false
                   } else {
                       self.leftButton.isEnabled = true
                       self.rightButton.isEnabled = true
                   }
                    self.countLabel.text = "1 of \(arts.count)"
                    self.adapter.performUpdates(animated: true, completion: { (done) in
                         self.art = arts.first
                         self.delegate?.setArts(arts: arts)
                    })
                }
            }
        }
    }
}
