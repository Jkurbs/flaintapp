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
    
    var result: (index: Int, count: Int, art: Art)? {
        didSet {
            showLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = .gray
        self.textAlignment = .center
    }
    
    func hideLabel() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] _ in
            UIView.animate(withDuration: 0.5) {
                self?.alpha = 0.0
            }
        }
    }
    
    @objc func showLabel() {
        guard let result = result else { return }
        self.text = "\(result.index + 1) of \(result.count)"
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
