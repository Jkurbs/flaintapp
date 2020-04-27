//
//  EmptyLabel.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

class OrientationView: UIView {
    
    var label = UILabel()
    
    var result: (index: Int, count: Int, art: Art)? {
        didSet {
            showLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func hideLabel() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            UIView.animate(withDuration: 0.5) {
                guard let self = self else { return }
                self.label.alpha = 0.0
            }
        }
    }
    
    @objc func showLabel() {
        guard let result = result else { return }
        label.text = "\(result.index + 1) of \(result.count)"
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AdjustView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let centerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addContraints()
    }
    
    func setupViews() {
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        alpha = 0.0
        isHidden = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.text = "1:00۟"
        addSubview(centerButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showView), name: .rotationStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel(_:)), name: .rotationChanged, object: nil)

    }
    
    @objc func showView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
            self.isHidden = false
        })
    }
    
    @objc func hideView() {
        UIView.animate(withDuration: 5.0, animations: {
            self.alpha = 0.0
            self.isHidden = true
            NotificationCenter.default.post(name: .recenterRotation, object: nil, userInfo: nil)
        }) { (finished) in
        }
    }
    
    @objc func updateLabel(_ notification: Notification) {
        if let info = notification.userInfo, let value = info["value"] as? Float {
            let roundedValue = value.rounded()
            label.text = String(roundedValue)
            if roundedValue == 0.0 {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()

            }
        }
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0),
            label.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            
            centerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4.0),
            centerButton.heightAnchor.constraint(equalToConstant: 20),
            centerButton.widthAnchor.constraint(equalToConstant: 20),
            centerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
        
        self.layer.cornerRadius = 5.0
    }
}
