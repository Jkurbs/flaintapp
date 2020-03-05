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
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleLabel, textField, contentView) { (titleLabel, textField, contentView) in
            titleLabel.left == contentView.left + 15
            titleLabel.height == contentView.height
            textField.right == contentView.right
            textField.height == contentView.height
            textField.width == 260
        }
    }
}
