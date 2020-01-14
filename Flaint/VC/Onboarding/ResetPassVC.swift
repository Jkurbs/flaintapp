//
//  ForgotPwdVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class ResetPassVC: UIViewController {
    
    var label: UILabel!
    var emailField: UITextField!
    var sendButton: UIBarButtonItem!
    
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label = UICreator.create.label("Reset password", 20, UIColor.darkText, .left, .medium, view)
        sendButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(send))
        sendButton.isEnabled = false
        navigationItem.rightBarButtonItem = sendButton
        
        emailField = UICreator.create.textField("Email address", .emailAddress, view)
        emailField.addTarget(self, action: #selector(edited(_:)), for: .editingChanged)
        emailField.backgroundColor = UIColor(red: 245.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        emailField.text = email ?? ""
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, emailField, view) { (label, emailField, view) in
            
            label.top == view.top + 150
            label.centerX == view.centerX
            
            emailField.top == label.bottom + 80
            emailField.centerX == view.centerX
            emailField.height == 45
            emailField.width == view.width - 40
        }
    }
    
    @objc func send() {
        
    
    }
    
    @objc func edited(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}













