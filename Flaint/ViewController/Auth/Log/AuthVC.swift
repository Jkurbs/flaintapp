//
//  LogInVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/27/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Foundation

enum AuthChoice {
    case login
    case register
}

class AuthVC: UIViewController {
    
    var segmentedCtrl: UISegmentedControl!
    
    var phone = ""
    var label = UILabel()
    var detailField = BgTextField()
    var pwdField = BgTextField()
    var nextButton = NextButton()
    
    var authChoice = AuthChoice.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)

        detailField.text = nil
        pwdField.text = nil
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -56.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedCtrl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24.0),
            segmentedCtrl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedCtrl.widthAnchor.constraint(equalTo: label.widthAnchor),
        
            detailField.topAnchor.constraint(equalTo: segmentedCtrl.bottomAnchor, constant: 40.0),
            detailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailField.widthAnchor.constraint(equalTo: label.widthAnchor),
            detailField.heightAnchor.constraint(equalToConstant: 46.0),
            
            pwdField.topAnchor.constraint(equalTo: detailField.bottomAnchor, constant: 8.0),
            pwdField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pwdField.widthAnchor.constraint(equalTo: label.widthAnchor),
            pwdField.heightAnchor.constraint(equalToConstant: 46.0),
            
            nextButton.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 16.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 46.0),
        ])
    }
    
    func setupViews() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "Log In"
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedCtrl = UISegmentedControl(items: ["Log In", "Register"])
        segmentedCtrl.selectedSegmentIndex = 0
        segmentedCtrl.translatesAutoresizingMaskIntoConstraints = false
        segmentedCtrl.addTarget(self, action: #selector(authChanged), for: .valueChanged)
        view.addSubview(segmentedCtrl)
        
        detailField.keyboardType = .emailAddress
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.backgroundColor = .fieldBackgroundColor
        detailField.placeholder = "email address"
        detailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailField)
        
        pwdField.isSecureTextEntry = true
        pwdField.backgroundColor = .fieldBackgroundColor
        pwdField.placeholder = "Password"
        pwdField.textContentType = .password
        pwdField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pwdField)
        
        nextButton.setTitle("Log In", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nextButton)
    }
    
    @objc func authChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            authChoice = .login
            self.label.text = "Log In"
            self.nextButton.setTitle("Log In", for: .normal)
        } else {
            authChoice = .register
            self.label.text = "Register"
            self.nextButton.setTitle("Register", for: .normal)
        }
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        if let email = self.detailField.text, let pwd = self.pwdField.text {
            if authChoice == .login {
                login(detail: email, pwd: pwd)
            } else {
                
            }
        }
    }
    
    
    func login(detail: String, pwd: String) {
        AuthService.shared.emailLogin(email: detail, pwd: pwd, complete: { userId, success, _ in
            if !success {
               // Show Error
            } else {
                let vc = ProfileVC()
               vc.userUID = userId
               let nav = UINavigationController(rootViewController: vc)
               nav.modalPresentationStyle = .fullScreen
               self.navigationController?.present(nav, animated: true, completion: nil)
               self.nextButton.hideLoading()
            }
        })
    }
    
    func registerNext() {
        let vc = UsernameVC()
        
        
    }
    
    
    @objc func textChanged() {
        if detailField.hasText && pwdField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
