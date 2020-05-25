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
    
    weak var delegate: ArtDescDelegate?
    
    
    var artDescription: String? {
        didSet {
            textView.text = artDescription
        }
    }
    
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
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .tertiarySystemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .label
        view.layer.addSublayer(separator)
        
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneBtn
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
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
    
    
    @objc func cancel() {
        guard textView.text != artDescription else {
            navigationController?.popViewController(animated: true)
            return
        }
        let alert = UIAlertController(title: "Discard Changes", message: "If you go back now, you will lose your changes.", preferredStyle: .actionSheet)
        let editing = UIAlertAction(title: "Keep editing", style: .default, handler: nil)
        
        let discard = UIAlertAction(title: "Discard changes", style: .destructive) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(editing)
        alert.addAction(discard)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func done() {
        delegate?.finishPassing(description: textView.text)
        navigationController?.popViewController(animated: true)
    }
}


