//
//  PhoneStepVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/7/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class PhoneStepVC: UIViewController {
    
    var label = UILabel()
    var textField = BgTextField()
    var nextButton = NextButton()
    var barView = BarView()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Enter the code we've sent to \n \(data[0])"
        label.numberOfLines = 4
        label.textAlignment = .center
        label.sizeToFit()
        
        view.addSubview(textField)
        textField.keyboardType = .numberPad
        textField.backgroundColor = .fieldBackgroundColor
        textField.placeholder = "Activation number"
        textField.textContentType = .oneTimeCode
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        
        view.addSubview(nextButton)
        
        let height = (navigationController?.toolbar.frame.size.height)! * 2
        barView.frame = CGRect(x: 0, y: self.view.frame.height - height, width: view.frame.width, height: height)
        barView.configure(first: nil, second: "Back")
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
            label.centerX == view.centerX
            
            textField.top == label.bottom + 60
            textField.centerX == view.centerX
            textField.width == label.width
            textField.height == 45

            nextButton.top == textField.bottom + 15
            nextButton.width == textField.width
            nextButton.height == 45
            nextButton.centerX == view.centerX
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        
        if let code = self.textField.text {
            self.data.append(code)
            let vc = ThirdStepVC()
            vc.data = self.data
            navigationController?.pushViewController(vc, animated: true)
            self.nextButton.hideLoading()
        }
    }
    
    
    @objc func textChanged() {
        if textField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
