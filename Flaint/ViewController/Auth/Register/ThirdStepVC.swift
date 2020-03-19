//
//  ThirdStepVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class ThirdStepVC: UIViewController {
    
    var label = UILabel()
    var descLabel = UILabel()
    var textField = BgTextField()
    var nextButton = NextButton()
    var barView = BarView()
    var data = [String]()
    
    var countryButton: UIButton!
    
    var countryList = CountryList()
    var country: String!
    var phoneExtension = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Add your name"
        label.font = UIFont.systemFont(ofSize: 25)
        
        view.addSubview(descLabel)
        descLabel.textAlignment = .center
        descLabel.text = "Add your name to be easily recognize."
        descLabel.textColor = .lightGray
        descLabel.font = UIFont.systemFont(ofSize: 14)
        
        view.addSubview(textField)
        textField.placeholder = "Full name"
        textField.autocapitalizationType = .words
        textField.backgroundColor = .fieldBackgroundColor
        textField.textContentType = .name

        
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
        
//        constrain(label, descLabel, textField, nextButton, view) { (label, descLabel, textField, nextButton, view) in
//
//            label.top == view.top + 80
//            label.width == view.width - 60
//            label.height == 30
//            label.centerX == view.centerX
//            
//            descLabel.top == label.bottom + 5
//            descLabel.width == label.width
//            descLabel.height == 20
//            descLabel.centerX == view.centerX
//            
//            textField.top == descLabel.bottom + 60
//            textField.centerX == view.centerX
//            textField.width == label.width
//            textField.height == 45
//            
//            nextButton.top == textField.bottom + 15
//            nextButton.width == textField.width
//            nextButton.height == 45
//            nextButton.centerX == view.centerX
//        }
    }

    

    
    @objc func nextStep() {
        self.nextButton.showLoading()
        if let name = textField.text {
            self.data.append(name)
            let vc = ChoosePwdVC()
            vc.data = self.data
            navigationController?.pushViewController(vc, animated: true)
            self.nextButton.hideLoading()
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func textChanged() {
        if textField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
