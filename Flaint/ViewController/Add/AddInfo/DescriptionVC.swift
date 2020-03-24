//
//  DescriptionVC.swift
//  Flaint
//
//  Created by Kerby Jean on 11/17/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class DescriptionVC: UIViewController {
    
    // MARK: - Properties
    
    var textView = UITextView()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.separator.cgColor
        return layer
    }()
    
    var delegate: ArtDescDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Functions
    
    func setupViews() {
        
        self.title = "Description"
        view.backgroundColor = .white
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .darkText
        view.layer.addSublayer(separator)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBtn
        
        let deadline = DispatchTime.now() + .milliseconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.textView.becomeFirstResponder()
        }
    }
    
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: 152.0),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: 150 - height, width: view.bounds.width, height: height)
    }
    
    
    @objc func done() {
        delegate?.finishPassing(description: textView.text)
        navigationController?.popViewController(animated: true)
    }
}
