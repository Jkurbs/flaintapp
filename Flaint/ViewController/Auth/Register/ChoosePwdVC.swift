//
//  ChoosePwdVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class ChoosePwdVC: UIViewController {
    
    var label = UILabel()
    var textField = BgTextField()
    var nextButton = NextButton()
    var barView = BarView()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Choose a Password"
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .fieldBackgroundColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0),
            label.heightAnchor.constraint(equalToConstant: 30),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.0),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: label.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: 48.0),
            
            nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: textField.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func nextStep() {
        nextButton.showLoading()
        let vc = FourthStepVC()
        if let pwd = self.textField.text {
            self.data.append(pwd)
            vc.data = self.data
            navigationController?.pushViewController(vc, animated: true)
            nextButton.hideLoading()
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
}
