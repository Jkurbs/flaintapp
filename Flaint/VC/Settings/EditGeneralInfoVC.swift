//
//  EditGeneralInfoVC.swift
//  Flaint
//
//  Created by Kerby Jean on 9/16/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import Foundation
import FirebaseAuth
import SwiftKeychainWrapper

class UpdateGeneralInfoVC: UIViewController {
    
    // MARK: - UI Elements
    
    var detailField = BgTextField()
    var nextButton = NextButton()
    var errorLabel = UILabel()
    var currentUser: Users?

    func setupUI() {
        
        view.backgroundColor = .backgroundColor
        
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


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(detailField, nextButton, errorLabel, view) { (detailField, nextButton, errorLabel, view) in
            detailField.top == view.top + 40
            detailField.centerX == view.centerX
            detailField.width == view.width - 80
            detailField.height == 45
            
            errorLabel.top == detailField.bottom + 5
            errorLabel.width == view.width - 50
            errorLabel.left == detailField.left
        
            nextButton.top == errorLabel.bottom + 15
            nextButton.width == detailField.width
            nextButton.height == 45
            nextButton.centerX == view.centerX
        }
    }
    
    
    @objc func nextStep() {
        Auth.auth().addStateDidChangeListener { auth, user in
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
        DataService.shared.RefUsers.child(user.uid).updateChildValues(["username": username]) { (error, ref) in
            if error != nil {self.showMessage("An error occured, try again", type: .success)}
            // Save to keychain
            KeychainWrapper.standard.removeObject(forKey: "username")
            KeychainWrapper.standard.set(username, forKey: "username")
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
            DataService.shared.checkUsername(username) { (success) in
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
