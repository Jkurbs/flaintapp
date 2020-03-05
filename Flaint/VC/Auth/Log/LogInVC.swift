//
//  LogInVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/27/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import Foundation

class LogInVC: UIViewController {
    
    var phone = ""
    var label = UILabel()
    var detailField = BgTextField()
    var pwdField = BgTextField()
    var nextButton = NextButton()
    var barView = BarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "Log In"
        label.textAlignment = .center
        label.sizeToFit()
        
        view.addSubview(detailField)
        detailField.keyboardType = .emailAddress
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.backgroundColor = .fieldBackgroundColor
        detailField.placeholder = "Phone number or email"
        detailField.textContentType = .username
        
        view.addSubview(pwdField)
        pwdField.isSecureTextEntry = true
        pwdField.backgroundColor = .fieldBackgroundColor
        pwdField.placeholder = "Password"
        pwdField.textContentType = .password
        
        nextButton.setTitle("Log In", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        
        view.addSubview(nextButton)
        
        let height = (navigationController?.toolbar.frame.size.height)! * 2
        barView.frame = CGRect(x: 0, y: self.view.frame.height - height, width: view.frame.width, height: height)
        barView.configure(first: "Dont have an account?  ", second: "Sign up.")
        barView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        view.addSubview(barView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)

        detailField.text =  nil
        pwdField.text = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, detailField, pwdField, nextButton, view) { (label, detailField, pwdField, nextButton, view) in
            
            label.top == view.top + 80
            label.width == view.width - 60
            label.centerX == view.centerX
            
            detailField.top == label.bottom + 40
            detailField.centerX == view.centerX
            detailField.width == label.width
            detailField.height == 45
            
            pwdField.top == detailField.bottom + 10
            pwdField.centerX == view.centerX
            pwdField.width == label.width
            pwdField.height == 45
            
            nextButton.top == pwdField.bottom + 15
            nextButton.width == pwdField.width
            nextButton.height == 45
            nextButton.centerX == view.centerX
        }
    }
    
    @objc func back() {
        let vc = FirstStepVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        if let text = self.detailField.text, let pwd = self.pwdField.text {
            self.emailLogin(detail: text, pwd: pwd)
        }
    }
    
    
    func emailLogin(detail: String, pwd: String) {
        AuthService.shared.emailLogin(email: detail, pwd: pwd, complete: { (userId, success, error) in
            if !success {
                self.phoneLogin(detail: detail, pwd: pwd)
            } else {
                self.goToVC(userId: userId ?? "")
            }
        })
    }
    
    
    func phoneLogin(detail: String, pwd: String) {
        AuthService.shared.PhoneAuth(phone: "+\(detail)", complete: { (success, error) in
            if !success {
                self.nextButton.hideLoading()
            } else {
                self.showAlert(phone: detail)
                self.nextButton.hideLoading()
                self.nextButton.disable()
            }
        })
    }
    
        
    func goToVC(userId: String) {
        let vc = ProfileVC()
        vc.userUID = userId
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
        self.nextButton.hideLoading()
    }
    
    
    @objc func textChanged() {
        if detailField.hasText && pwdField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
    
    
    func showAlert(phone: String) {
        let alert = UIAlertController(title: "Code sent", message: "Enter the code we've sent to \n \(phone)", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Verification code"
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let log = UIAlertAction(title: "Log In", style: .cancel) { (action) in
            self.nextButton.showLoading()
            let textField = alert.textFields![0] as UITextField
            AuthService.shared.phoneLogIn(code: textField.text!, complete: { (success, error, userId) in
                if !success {
                    print("error:", error!)
                    self.nextButton.hideLoading()
                } else {
                    self.goToVC(userId: userId ?? "")
                }
            })
        }
        
        alert.addAction(cancel)
        alert.addAction(log)
        self.present(alert, animated: true, completion: nil)
    }
}
