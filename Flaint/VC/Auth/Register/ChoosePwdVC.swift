//
//  ChoosePwdVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

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
        
        view.addSubview(textField)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .fieldBackgroundColor
        
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
        
        constrain(label, textField, nextButton, view) { (label, textField, nextButton, view) in
            
            label.top == view.top + 80
            label.width == view.width - 60
            label.height == 30
            label.centerX == view.centerX
            
            textField.top == label.bottom + 20
            textField.centerX == view.centerX
            textField.width == label.width
            textField.height == 45
            
            nextButton.top == textField.bottom + 15
            nextButton.width == textField.width
            nextButton.height == 45
            nextButton.centerX == view.centerX
        }
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
