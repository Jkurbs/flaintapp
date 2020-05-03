//
//  UsernameVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/10/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class UsernameVC: UIViewController {
    
    var label = UILabel()
    var nameTextField = BgTextField()
    var usernameTextField = BgTextField()
    var errorLabel = UILabel()
    var nextButton = NextButton()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Add your full name\nand choose a Username"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameTextField)
        nameTextField.placeholder = "Full name"
        nameTextField.backgroundColor = .fieldBackgroundColor
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(usernameTextField)
        usernameTextField.placeholder = "Username"
        usernameTextField.backgroundColor = .fieldBackgroundColor
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(errorLabel)
        errorLabel.font = UIFont.systemFont(ofSize: 10)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24.0),
            nameTextField.widthAnchor.constraint(equalTo: label.widthAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 48.0),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8.0),
            usernameTextField.widthAnchor.constraint(equalTo: label.widthAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 48.0),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func nextStep() {
        
        nextButton.showLoading()
        
        if let name = nameTextField.text?.split(separator: " "), let firstName = name.first?.description, let lastName = name.last?.description, let username = usernameTextField.text?.lowercased().trimmingCharacters(in: .whitespaces), let email = data.first,
            let password = data.last {
            AuthService.shared.createAccount(firstName: firstName, lastName: lastName, username: username, email: email, pwd: password) { _, error in
                if let error = error {
                    NSLog("error: \(error)")
                    self.nextButton.hideLoading()
                } else {
                    DataService.shared.saveUsername(username)
                    self.nextButton.hideLoading()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.observeAuthorisedState()
                }
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func textChanged() {
        if nameTextField.hasText && usernameTextField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
    
    
    //
    //    func alert(_ phone: String) -> String {
    //        let alert = UIAlertController(title: "Code sent", message: "Enter the code we've sent to \n \(phone)", preferredStyle: .alert)
    //        alert.addTextField(configurationHandler: { (textField) -> Void in
    //            textField.placeholder = "Code"
    //        })
    //        let done = UIAlertAction(title: "Done", style: .default) { action in
    //            if let code = alert.textFields?.first?.text {
    //                let defaults = UserDefaults.standard
    //
    //
    //            }
    //        }
    //    }
}

extension UsernameVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField.hasText {
//            let username = textField.text!.lowercased().trimmingCharacters(in: .whitespaces)
//            DataService.shared.checkUsername(username) { success in
//                if !success {
//                    DispatchQueue.main.async {
//                        self.errorLabel.text = "Username already taken"
//                        self.nextButton.disable()
//                        self.errorLabel.textColor = .error
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorLabel.text = "Username available"
//                        self.nextButton.enable()
//                        self.errorLabel.textColor = .success
//                    }
//                }
//            }
//        }
    }
}
