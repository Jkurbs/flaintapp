//
//  RegisterVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class RegisterVC: UIViewController {
    
    var registerButton: UIButton!
    var createLabel: UILabel!
    var createButton: UIButton!
    var label: UILabel!
    var emailPhoneField: FieldRect!
    var passwordField: FieldRect!
    var resetButton: UIButton!
    var separator = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: SetupViews
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        registerButton = UICreator.create.button("Sign In", nil, .white, .red, view)
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
        registerButton.layer.cornerRadius = 5
        registerButton.backgroundColor = UIColor.red
        registerButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        createLabel = UICreator.create.label("Have an account?", 13, .lightGray, .left, .medium, view)
        createLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAccount)))
        createLabel.isUserInteractionEnabled = true
        
        createButton = UICreator.create.button("Login", nil, .red, nil, view)
        createButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        label = UICreator.create.label("Flaint", 35, .darkText, .center, .medium, view)
        emailPhoneField = UICreator.create.textField("Email or phone number", .default, view)
        
        emailPhoneField.backgroundColor = UIColor.backgroundColor
        
        passwordField = UICreator.create.textField("Password", .default, view)
        passwordField.isSecureTextEntry = true
        
        resetButton = UICreator.create.button("Forgot?", nil, view.tintColor, nil, view)
        resetButton.setTitleColor(.gray, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        emailPhoneField.text = email
        
        separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(separator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, emailPhoneField, passwordField, resetButton, registerButton, createLabel, createButton, separator, view) { (label, emailPhoneField, passwordField, resetButton, registerButton, createLabel, createButton, separator, view) in
            
            label.top == view.top + 150
            label.centerX == view.centerX
            
            emailPhoneField.top == label.bottom + 80
            emailPhoneField.centerX == view.centerX
            emailPhoneField.height == 45
            emailPhoneField.width == view.width - 40
            
            passwordField.top == emailPhoneField.bottom + 10
            passwordField.centerX == view.centerX
            passwordField.width == view.width - 40
            passwordField.height == 45
            
            resetButton.top == emailPhoneField.bottom + 10
            resetButton.centerY == passwordField.centerY
            resetButton.right == passwordField.right - 10
            
            registerButton.top == passwordField.bottom + 60
            registerButton.centerX == view.centerX
            registerButton.height == 50
            registerButton.width == view.width - 40
            
            createLabel.top == view.bottom - 80
            createLabel.left == view.left + 65
            createLabel.height == 80
            
            createButton.top == view.bottom - 80
            createButton.right == createLabel.right + 60
            createButton.height == 80
            
            separator.top == createButton.top
            separator.width == view.width
            separator.height == 0.5
        }
    }
    
    
    // MARK: Actions
    
    @objc func login() {
        
        registerButton.isEnabled = false
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        if #available(iOS 13.0, *) {
//            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
            activityIndicator.style = .gray
        }
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
//        if let email = emailPhoneField.text, let pass = passwordField.text {
//            
//        }
    }
    
    @objc func resetPassword() {
        let vc = ResetPassVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createAccount() {
        let pageVC = OnboardingVC()
        self.present(pageVC, animated: true, completion: nil)
    }
    
    
    @objc func textChanged(_ textField: UITextField) {
        if emailPhoneField.hasText && passwordField.hasText  {
            registerButton.isEnabled = true
            registerButton.alpha = 1.0
        } else {
            registerButton.isEnabled = false
            registerButton.alpha = 0.5
        }
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
