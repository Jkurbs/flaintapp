//
//  EmptyLabel.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

class CountLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = .gray
        self.textAlignment = .center
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLabel), name: NSNotification.Name(rawValue: "count"), object: nil)
    }
    
    func hideLabel() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] (timer) in
            UIView.animate(withDuration: 0.5) {
                self?.alpha = 0.0
            }
        }
    }
    
    
    @objc func showLabel(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let index = dict["index"] as? Int, let count = dict["count"] as? Int {
                self.text = "\(index + 1) of \(count)"
                UIView.animate(withDuration: 0.5) {
                    self.alpha = 1.0
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
