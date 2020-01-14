//
//  FourthStepVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/10/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import FirebaseAuth

class FourthStepVC: UIViewController {
    
    var label = UILabel()
    var textField = BgTextField()
    var errorLabel = UILabel()
    var nextButton = NextButton()
    var barView = BarView()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Choose a Username"
        label.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(textField)
        textField.placeholder = "Username"
        textField.backgroundColor = .fieldBackgroundColor
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(errorLabel)
        errorLabel.font = UIFont.systemFont(ofSize: 10)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        view.addSubview(nextButton)
        
        let height = (navigationController?.toolbar.frame.size.height)! * 2
        barView.frame = CGRect(x: 0, y: self.view.frame.height - height, width: view.frame.width, height: height)
        barView.configure(first: "Already have an account?  ", second: "Log In.")
        barView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        view.addSubview(barView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, textField, errorLabel, nextButton, view) { (label, textField, errorLabel, nextButton, view) in
            
            label.top == view.top + 80
            label.width == view.width - 60
            label.height == 30
            label.centerX == view.centerX
            
            textField.top == label.bottom + 20
            textField.centerX == view.centerX
            textField.width == label.width
            textField.height == 45
            
            errorLabel.top == textField.bottom + 5
            errorLabel.width == view.width - 50
            errorLabel.left == textField.left
            
            nextButton.top == errorLabel.bottom + 15
            nextButton.width == textField.width
            nextButton.height == 45
            nextButton.centerX == view.centerX
        }
    }
    
    @objc func nextStep() {
        
        nextButton.showLoading()
        
        if let username = textField.text?.lowercased().trimmingCharacters(in: .whitespaces) {
            let phone = data[0]
            let email = data[1]
            let code = data[2]
            let name = data[3]
            let pwd = data[4]
            
            AuthService.shared.createAccount(phone: phone, code: code, name: name, username: username, email: email, pwd: pwd) { (success, error) in
                if let error = error {
                    print("error:", error.localizedDescription)
                    self.nextButton.hideLoading()
                } else {
                    DataService.shared.saveUsername(username)
                    let vc = ProfileVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(nav, animated: true, completion: nil)
                    self.nextButton.hideLoading()
                }
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func textChanged() {
        if textField.hasText {
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

extension FourthStepVC: UITextFieldDelegate {
    
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

