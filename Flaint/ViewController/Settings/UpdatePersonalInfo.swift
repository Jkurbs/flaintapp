//
//  UpdatePersonalInfo.swift
//  Flaint
//
//  Created by Kerby Jean on 8/15/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

class UpdatePersonalInfoVC: UIViewController {
    
    // MARK: - UI Elements
    
    var detailField = BgTextField()
    var nextButton = NextButton()
    
    var isEmail = false
    private var handle: AuthStateDidChangeListenerHandle!
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailField)
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.backgroundColor = .fieldBackgroundColor
        detailField.translatesAutoresizingMaskIntoConstraints = false
        if isEmail {
            detailField.keyboardType = .emailAddress
            self.title = "Email"
            detailField.placeholder = "Email address"
        } else {
            detailField.keyboardType = .phonePad
            self.title = "Phone"
            detailField.placeholder = "Phone number"
        }
        
        nextButton.setTitle("Update", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
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
            detailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 80.0),
            detailField.heightAnchor.constraint(equalToConstant: 48.0),
            
            nextButton.topAnchor.constraint(equalTo: detailField.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: detailField.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func nextStep() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let currentUser = user {
                self.enterPwd(currentUser)
            } else {
                print("User is signed out.")
                self.showMessage("Please log out and log in again", type: .error)
            }
        }
    }
    
    func enterPwd(_ user: User) {
        nextButton.showLoading()
        
        if let pwd = UserDefaults.standard.string(forKey: "pwd") {
            self.authenticate(user: user, pwd: pwd)
        } else {
            // Show alert for password
            let alert = UIAlertController(title: "Enter password", message: "Enter your password for \(user.email!)", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField -> Void in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            })
            let done = UIAlertAction(title: "Done", style: .default) { _ in
                if let pwd = alert.textFields?.first?.text {
                    self.authenticate(user: user, pwd: pwd)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(done)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func authenticate(user: User, pwd: String) {
        let newEmail = self.detailField.text!
        let username = UserDefaults.standard.string(forKey: "username")
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: pwd)
        user.reauthenticate(with: credential, completion: { _, error in
            if let err = error {
                self.showMessage("An error occured, \(err.localizedDescription)", type: .error)
                self.nextButton.hideLoading()
            } else {
                if self.isEmail {
                    user.updateEmail(to: newEmail, completion: { error in
                        if let err = error {
                            self.showMessage("Error updating email, \(err.localizedDescription)", type: .error)
                            self.nextButton.hideLoading()
                        }
                        DataService.shared.RefUsers.child(user.uid).updateChildValues(["email": newEmail], withCompletionBlock: { error, _ in
                            if let err = error {
                                self.showMessage("\(err.localizedDescription)", type: .error)
                                self.nextButton.hideLoading()
                            }
                            DataService.shared.RefUsernameAuthLink.child(username!).setValue(newEmail)
                            UserDefaults.standard.removeObject(forKey: "email")
                            UserDefaults.standard.set(newEmail, forKey: "email")
                            DispatchQueue.main.async {
                                self.nextButton.hideLoading()
                                self.showMessage("Email successfully updated", type: .success)
                            }
                        })
                    })
                } else {
                    let phone = self.detailField.text!
                    AuthService.shared.PhoneAuth(phone: phone, complete: { success, error in
                        if let err = error {
                            self.showMessage("Error: \(err.localizedDescription)", type: .error)
                        } else {
                            let alert = UIAlertController(title: "Code sent", message: "Enter the code we've sent to \n \(phone)", preferredStyle: .alert)
                            alert.addTextField(configurationHandler: { textField -> Void in
                                textField.placeholder = "Code"
                            })
                            let done = UIAlertAction(title: "Done", style: .default) { _ in
                                if let code = alert.textFields?.first?.text {
                                    let defaults = UserDefaults.standard
                                    let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
                                    user.updatePhoneNumber(credential, completion: { error in
                                        if let err = error {
                                            print("Error:", err.localizedDescription)
                                            self.showMessage("Error updating phone try again", type: .error)
                                        } else {
                                            self.showMessage("Phone number successfully updated", type: .success)
                                            self.nextButton.hideLoading()
                                        }
                                    })
                                }
                            }
                            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            alert.addAction(done)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        })
    }
    

    @objc func textChanged() {
        if detailField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
