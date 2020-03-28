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
        self.arts.removeAll()
        DataService.shared.fetchCurrentUserArt(userId: userUID!) { result in
            if let art = try? result.get() as? Art {
                DispatchQueue.main.async {
                    self.arts.append(art)
                    self.arts = self.arts.sorted { $0.index < $1.index }
                    if self.arts.count == 1 {
                        self.toolbarItems?[1].isEnabled = false
                        self.toolbarItems?[5].isEnabled = false
                    } else {
                        self.toolbarItems?[1].isEnabled = false
                        self.toolbarItems?[5].isEnabled = true
                    }
                    self.countLabel.text = "1 of \(self.arts.count)"
                    self.currentArt = self.arts.first
                    self.delegate?.fetchArts(arts: self.arts)
                }
            }
        }
    }
}
