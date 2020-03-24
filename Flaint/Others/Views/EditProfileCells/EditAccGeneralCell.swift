//
//  EditAccGeneralCell.swift
//  Flaint
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class EditAccountGeneralCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var textField = FieldRect()
    var valueLabel = UILabel()
    
    let separator: UIView = {
        let layer = UIView()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return layer
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UICreator.create.label(nil, 15, .darkText, .natural, .medium, contentView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.font = UIFont.normal
        textField.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font =  UIFont.normal
        valueLabel.textColor = .darkText
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(valueLabel)
        contentView.addSubview(textField)
//        contentView.addSubview(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            textField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8.0),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -titleLabel.frame.width),
        ])
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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(valueLabel)
//        contentView.addSubview(separator)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8.0),
            valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -titleLabel.frame.width),
        ])
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
