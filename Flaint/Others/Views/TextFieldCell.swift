//
//  TextFieldCell.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    var textField = FieldRect()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.frame = contentView.frame
        textField.font = UIFont.normal
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(placeholder: String) {
        textField.placeholder = placeholder
    }
}


class CurrentPasswordCell: UITableViewCell {
    
    var textField = FieldRect()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.font = UIFont.normal
        textField.textColor = .darkText
        textField.placeholder = "Current password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = contentView.frame
        
    }
}

class NewPasswordCell: UITableViewCell {
    
    var textField = FieldRect()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.textColor = .darkText
        textField.placeholder = "New password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = contentView.frame
    }
}

class RepeatNewPasswordCell: UITableViewCell {
    
    var textField = FieldRect()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.textColor = .darkText
        textField.placeholder = "Retype new password"
        textField.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = contentView.frame
    }
}
