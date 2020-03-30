//
//  EmptyLabel.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

class OrientationView: UIView {
    
    var label = UILabel()
    
    var result: (index: Int, count: Int, art: Art)? {
        didSet {
            showLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
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
        label.text = "\(result.index + 1) of \(result.count)"
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
