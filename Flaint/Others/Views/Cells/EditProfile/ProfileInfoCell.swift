//
//  ProfileInfoCell.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var textField = FieldRect()
    
    
    var title: String! {
        didSet {
            textField.placeholder = title
            titleLabel.text = title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UICreator.create.label(nil, 15, .darkText, .natural, .regular, contentView)
        contentView.addSubview(textField)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
        
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            textField.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16.0)
        ])

    }
}
