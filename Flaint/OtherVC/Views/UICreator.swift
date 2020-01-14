//
//  UICreator.swift
//  Flaint
//
//  Created by Kerby Jean on 4/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit


class UICreator {
    
    private static let _create = UICreator()
    
    static var create: UICreator {
        return _create
    }
    
    func button(_ title: String?, _ image: UIImage?, _ color: UIColor?, _ backgroundColor: UIColor?, _ contentView: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }
    
    func label(_ text: String?, _ fontSize: CGFloat?, _ textColor: UIColor?, _ alignment: NSTextAlignment, _ weight: UIFont.Weight, _ contentView: UIView) -> UILabel {
        let label = UILabel()
        label.text = text
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: fontSize!, weight: weight)
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = 4
        contentView.addSubview(label)
        return label
    }
    
    
    
    func imageView(_ image: UIImage?, _ contentView: UIView) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        return imageView
    }
    
    
    func textField(_ placeholder: String?, _ keyboardType: UIKeyboardType, _ contentView: UIView) -> FieldRect {
        let field = FieldRect()
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .darkText
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = keyboardType
        field.placeholder = placeholder
        field.backgroundColor = UIColor.backgroundColor
        field.layer.cornerRadius = 5
        field.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        field.layer.borderWidth = 0.4
        contentView.addSubview(field)
        return field
    }
    
    func textView (_ contentView: UIView) -> UITextView {
        let field = UITextView()
        field.textColor = .darkText
        field.isUserInteractionEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(field)
        return field
    }
}

