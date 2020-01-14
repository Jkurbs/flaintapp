//
//  ProfileInfoCell.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography


class ProfileInfoCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var textField = FieldRect()
    
    let separator: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return layer
    }()
    
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UICreator.create.label(nil, 15, .darkText, .natural, .regular, contentView)
        contentView.addSubview(textField)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        contentView.addSubview(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleLabel, textField, separator, contentView) { (titleLabel, textField, separator, contentView) in
            titleLabel.left == contentView.left + 15
            titleLabel.height == contentView.height
            textField.right == contentView.right
            textField.height == contentView.height
            textField.width == 260
            
            separator.right == contentView.right - 10
            separator.height == 0.5
            separator.width == textField.width
            separator.bottom == contentView.bottom
        }
        
        //        separator.frame = CGRect(x: 0, y: bounds.height - height, width: textField.frame.width, height: height)
    }
    
    func configure(title: String) {

        textField.placeholder = title
        titleLabel.text = title
    }
}
