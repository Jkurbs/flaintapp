//
//  StepOneVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/7/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class FirstStepVC: UIViewController, CountryListDelegate {
    
    var segment: UISegmentedControl!
    var phoneField = BgTextField()
    var emailField = BgTextField()
    var barView = BarView()
    
    var countryButton: UIButton!
    
    var countryList = CountryList()
    var country: String!
    var phoneExtension = "1"
    var nextButton = NextButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        constrain(phoneField, emailField, nextButton, view) { (phoneField, emailField, nextButton, view) in
//            
//            phoneField.top == view.top + 100
//            phoneField.centerX == view.centerX
//            phoneField.width == view.width - 60
//            phoneField.height == 45
//
//            emailField.top == phoneField.bottom + 10
//            emailField.centerX == view.centerX
//            emailField.width == phoneField.width
//            emailField.height == 45
//            
//            nextButton.top == emailField.bottom + 15
//            nextButton.width == emailField.width
//            nextButton.height == 45
//            nextButton.centerX == view.centerX
//        }
    }
    
    
    func setupView() {
        
        view.backgroundColor = .backgroundColor
        
        countryList.delegate = self
        
        view.addSubview(phoneField)
        phoneField.backgroundColor = .fieldBackgroundColor
        phoneField.placeholder = "Phone number"
        phoneField.keyboardType = .phonePad
        phoneField.textContentType = .telephoneNumber
        
        countryButton = phoneField.button("US +1")
        countryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        countryButton.addTarget(self, action: #selector(presentCountryList), for: .touchUpInside)
        
        view.addSubview(emailField)
        emailField.backgroundColor = .fieldBackgroundColor
        emailField.placeholder = "Email Address"
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(phoneStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
        view.addSubview(nextButton)
        
        let height = (navigationController?.toolbar.frame.size.height)! * 2
        barView.frame = CGRect(x: 0, y: self.view.frame.height - height, width: view.frame.width, height: height)
        barView.configure(string: "Already have an account?  ", comment: "Log In.")
        barView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        view.addSubview(barView)
    }
    
    
    @objc func textChanged(_ textField: UITextField) {
        if phoneField.hasText || emailField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
    
    @objc func phoneStep() {
        self.nextButton.showLoading()
        let vc = PhoneStepVC()
        var phone: String
        if !(self.phoneField.text?.contains("+1"))! {
             phone = "+\(self.phoneExtension)\(phoneField.text ?? "")"
        } else {
             phone = "\(phoneField.text ?? "")"
        }
        let email = self.emailField.text!
        
        vc.data.append(phone)
        vc.data.append(email)
        AuthService.shared.PhoneAuth(phone: phone) { (success, error) in
            if !success {
                print("ERROR::" ,error!.localizedDescription)
                self.nextButton.hideLoading()
            } else {
                UserDefaults.standard.set(true, forKey: "phone")
                self.nextButton.hideLoading()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FirstStepVC {
    
    @objc func presentCountryList() {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func selectedCountry(country: Country) {
        self.country = country.name
        self.phoneExtension = country.phoneExtension
        countryButton.setTitle("\(country.countryCode) +\(country.phoneExtension)", for: .normal)
    }
}

