//
//  EditGeneralInfoVC.swift
//  Flaint
//
//  Created by Kerby Jean on 9/16/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class UpdateGeneralInfoVC: UIViewController {
    
    // MARK: - UI Elements
    
    var detailField = BgTextField()
    var nextButton = NextButton()
    var errorLabel = UILabel()
    var currentUser: Users?
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailField)
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.backgroundColor = .fieldBackgroundColor
        
        detailField.placeholder = "Username"
        detailField.delegate = self
        detailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(errorLabel)
        errorLabel.font = UIFont.systemFont(ofSize: 10)
        
        nextButton.setTitle("Update", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        view.addSubview(nextButton)
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            detailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            detailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80.0),
            detailField.heightAnchor.constraint(equalToConstant: 48.0),
            
            errorLabel.topAnchor.constraint(equalTo: detailField.bottomAnchor, constant: 8.0),
            errorLabel.widthAnchor.constraint(equalTo: detailField.widthAnchor),
            errorLabel.leftAnchor.constraint(equalTo: detailField.leftAnchor),
            
            nextButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: detailField.widthAnchor),
            nextButton.heightAnchor.constraint(equalTo: detailField.heightAnchor),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func nextStep() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let currentUser = user {
                self.updateUsername(user: currentUser)
            } else {
                self.showMessage("Please log out and log in again", type: .error)
            }
        }
    }
    
    func updateUsername(user: User) {
        
        let username = self.detailField.text!
        // Remove old username
        DataService.shared.removeUsername(username: currentUser?.username ?? "")
        // Save new username
        DataService.shared.saveUsername(username)
        // Save new auth username
        DataService.shared.updateUsernameAuth(username)
        // Update username
        DataService.shared.RefUsers.child(user.uid).updateChildValues(["username": username]) { error, _ in
            if error != nil { self.showMessage("An error occured, try again", type: .success) }
            // Save to keychain
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.set(username, forKey: "username")
            DispatchQueue.main.async {
                self.showMessage("Username successfully updated", type: .success)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @objc func textChanged() {
        if detailField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}

extension UpdateGeneralInfoVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.hasText {
            let username = textField.text!.lowercased().trimmingCharacters(in: .whitespaces)
            DataService.shared.checkUsername(username) { success in
                if !success {
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Username already taken"
                        self.nextButton.disable()
                        self.errorLabel.textColor = .error
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Username available"
                        self.nextButton.enable()
                        self.errorLabel.textColor = .success
                    }
                }
            }
        }
    }
}
