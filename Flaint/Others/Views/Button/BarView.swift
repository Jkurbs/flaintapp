//
//  BarView.swift
//  Flaint
//
//  Created by Kerby Jean on 7/9/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class BarView: UIView {

    var separator = UIView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false 
        
        self.addSubview(separator)
        separator.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
        
            separator.topAnchor.constraint(equalTo:  self.topAnchor),
            separator.heightAnchor.constraint(equalToConstant:  0.5),
            separator.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            label.widthAnchor.constraint(equalTo:  self.widthAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(string: String?, comment: String?) {
        
        let textAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let buttonAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.flaint]
        
        let text = NSMutableAttributedString(string: string ?? "", attributes:textAttrs)
        let buttonText = NSMutableAttributedString(string: comment ?? "", attributes:buttonAttrs)
        
        text.append(buttonText)
        self.label.attributedText = text
    }
}
