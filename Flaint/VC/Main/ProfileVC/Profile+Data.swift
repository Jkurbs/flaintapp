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
        self.arts.removeAll()
        
        DataService.shared.fetchCurrentUserArt { result in
            if let art = try? result.get() as? Art {
                self.arts.append(art)
//                self.delegate?.arts = self.arts
                if self.arts.count == 1 {
                    self.leftButton.isEnabled = false
                    self.rightButton.isEnabled = false
                } else {
                    self.leftButton.isEnabled = true
                    self.rightButton.isEnabled = true
                }
                
                self.countLabel.text = "1 of \(self.arts.count)"
                self.adapter.performUpdates(animated: true, completion: { (done) in
                    NotificationCenter.default.post(name: Notification.Name("count"), object: nil, userInfo: ["count": self.arts.count, "arts": self.arts])
                })
            }
        }
    }
    
    
    @objc func getImg(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let art = dict["art"] as? Art {
                self.art = art
                let url = URL(string: art.imgUrl)!
                DataService.shared.getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    let img = UIImage(data: data)
                    self.artImg = img
                }
            }
        }
    }
}
