//
//  PhoneTextField.swift
//  Flaint
//
//  Created by Kerby Jean on 7/7/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class BgTextField: UITextField, UITextFieldDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
        setup()
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        let font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.font = font
        self.textColor = UIColor.darkGray
        self.borderStyle = .roundedRect
        self.clearButtonMode = .whileEditing
        self.tintColor = .flaint
        self.autocorrectionType = .no
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("focused")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("lost focus")
    }
    
    
    func button(_ title: String? = nil, iconName: String? = nil) -> UIButton {
        self.leftView = nil
        self.rightView = nil
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.70, height: self.frame.height * 0.70)
        if title != nil {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.setTitle(title, for: UIControl.State())
            button.setTitleColor(.flaint, for: UIControl.State())
            button.setTitleColor(UIColor.gray, for: .disabled)
            self.leftViewMode = .always
            self.leftView = button
        }
        
        if iconName != nil {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
            button.setImage(UIImage(named: iconName!), for: UIControl.State())
            self.rightViewMode = .always
            self.rightView = button
        }
        
        return button
    }
    
    
    func ifPasswordValid(_ password: String) -> Bool {
        let passwordValidated = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordValidated.evaluate(with: password)
    }
    
    
    @IBInspectable public var rightViewImage: UIView {
        get {
            return self.rightView!
        }
        set {
            self.rightView = newValue
        }
    }
}








