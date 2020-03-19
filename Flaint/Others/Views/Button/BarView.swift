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
        
        self.addSubview(separator)
        separator.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        constrain(separator, label, self) { (separator, label, self) in
//            separator.top == self.top
//            separator.height == 0.5
//            separator.width == self.width
//            
//            label.width == self.width - 60
//            label.center == self.center
//            label.height == 30
//        }
    }
    
    func configure(first: String?, second: String?) {
        
        let textAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        let buttonAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.flaint]
        
        let text = NSMutableAttributedString(string: first ?? "", attributes:textAttrs)
        let buttonText = NSMutableAttributedString(string: second ?? "", attributes:buttonAttrs)
        
        text.append(buttonText)
        self.label.attributedText = text
    }
}
