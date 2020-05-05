//
//  TextFieldRect.swift
//  Flaint
//
//  Created by Kerby Jean on 6/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import UIKit

class FieldRect: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 15, dy: 0)
    }
}

extension UITextField {
    
    func setBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func setPlaceHolderColor(_ placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
}
