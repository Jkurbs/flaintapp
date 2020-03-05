//
//  EditAccGeneralCell.swift
//  Flaint
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class EditAccountGeneralCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var textField = FieldRect()
    var valueLabel = UILabel()
    
    let separator: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return layer
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UICreator.create.label(nil, 15, .darkText, .natural, .medium, contentView)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.font = UIFont.normal
        valueLabel.font =  UIFont.normal
        valueLabel.textColor = .darkText 
        contentView.addSubview(valueLabel)
        contentView.addSubview(textField)
        contentView.addSubview(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleLabel, textField, valueLabel, separator, contentView) { (titleLabel, textField, valueLabel, separator, contentView) in
            titleLabel.left == contentView.left + 15
            titleLabel.height == contentView.height
            textField.right == contentView.right
            textField.height == contentView.height
            textField.width == 260
            
            valueLabel.left == textField.left + 15
            valueLabel.height == contentView.height
            valueLabel.width == 260
            
            separator.right == contentView.right - 10
            separator.height == 0.5
            separator.width == textField.width
            separator.bottom == contentView.bottom
        }
    }
    
    func configure(index: Int, title: String, item: AccountModelItem) {
        guard let item = item as? AccountViewModelGeneralItem else {
            return
        }
        textField.placeholder = title
        titleLabel.text = title
        
        if index == 1 {
            textField.text = item.name
        } else {
            textField.isHidden = true
        }
    }
}

class EditAccountPrivateCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var valueLabel = UILabel()
    
    let separator: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return layer
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UICreator.create.label("", 15, .darkText, .natural, .medium, contentView)
        valueLabel.font = UIFont.normal
        contentView.addSubview(valueLabel)
        contentView.addSubview(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleLabel, valueLabel, separator, contentView) { (titleLabel, valueLabel, separator, contentView) in
            titleLabel.left == contentView.left + 15
            titleLabel.height == contentView.height
            
            valueLabel.right == contentView.right
            valueLabel.height == contentView.height
            valueLabel.width == 260
            
            separator.right == contentView.right - 10
            separator.height == 0.5
            separator.width == valueLabel.width
            separator.bottom == contentView.bottom
        }
    }
    
    
    func configure(index: Int, title: String, item: AccountModelItem) {
        guard let item = item as? AccountViewModelPersonalItem else {
            return
        }
        titleLabel.text = title
        if index == 0 {
            if item.email == "" {
                valueLabel.text = "Add email address"
                valueLabel.textColor = .gray
            } else {
                valueLabel.text = item.email
            }
        } else {
            if item.phone == "" {
                valueLabel.text = "Add phone number"
                valueLabel.textColor = .gray
            } else {
                valueLabel.text = item.phone
            }
        }
    }
}
