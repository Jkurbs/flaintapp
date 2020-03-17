//
//  DescriptionVC.swift
//  Flaint
//
//  Created by Kerby Jean on 11/17/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class DescriptionVC: UIViewController {

    // MARK: - Properties
    
    var textView = UITextView()
    
    let separator: CALayer = {
      let layer = CALayer()
      layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
      return layer
    }()
    
    var delegate: ArtDescDelegate?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Functions
    
    func setupViews() {
        
        self.title = "Description"
        view.backgroundColor = .white
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.tintColor = .darkText
        textView.backgroundColor = .white
        view.layer.addSublayer(separator)
                
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBtn
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.textView.becomeFirstResponder()
        }
    }
    
    func layoutViews() {
        constrain(textView, view) { (textView, view) in
            textView.height == 150
            textView.width == view.width
            textView.top == view.top
        }
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: 150 - height, width: view.bounds.width, height: height)
    }
    

    @objc func done() {
        delegate?.finishPassing(description: textView.text)
        navigationController?.popViewController(animated: true)
    }
}
