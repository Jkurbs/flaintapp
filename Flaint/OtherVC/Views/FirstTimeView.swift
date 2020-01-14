//
//  FirstTimeView.swift
//  Flaint
//
//  Created by Kerby Jean on 6/5/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class FirsTimeView: UIView {
    
    var imageView: UIImageView!
    var label: UILabel!
    var descLabel: UILabel!
    var button = UIButton()
    var arImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(image: UIImage(named: "Wall-art"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        self.backgroundColor = .backgroundColor
        label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Use AR to show your painting on a wall"
        self.addSubview(label)
        
        descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.text = "Start by allowing access to your camera"
        descLabel.numberOfLines = 5
//        self.addSubview(descLabel)
        
//        arImageView = UIImageView(image: 􀘸)
        
        button.setTitle("VIEW IN AR", for: .normal)
        button.setTitleColor(self.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 300)
        
        label.frame = CGRect(x: 0, y: imageView.frame.height + 30, width: self.frame.width, height: 60)
//        descLabel.frame = CGRect(x: 0, y: label.layer.position.y + 10, width: self.frame.width, height: 60)
        button.frame = CGRect(x: 0, y: label.layer.position.y + 20, width: self.frame.width, height: 30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
