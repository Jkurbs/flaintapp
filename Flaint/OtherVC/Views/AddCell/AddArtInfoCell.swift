//
//  AddArtInfoCell.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class AddArtInfoCell: UITableViewCell {
    
    var titleField = FieldRect()
    var priceField = FieldRect()
    var artImageView = UIImageView()
    
    var viewController: UIViewController!
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let font = UIFont.systemFont(ofSize: 15)
        
        titleField.font = font
        titleField.clearButtonMode = .always
        titleField.setPlaceHolderColor("Name")
        contentView.addSubview(titleField)
        
        priceField.font = font
        priceField.clearButtonMode = .always
        priceField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        priceField.setPlaceHolderColor("Price")
        priceField.keyboardType = .numberPad
        contentView.addSubview(priceField)
        
        artImageView.contentMode = .scaleAspectFit
        artImageView.isUserInteractionEnabled = true 
        artImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        contentView.addSubview(artImageView)
        
        
        contentView.layer.addSublayer(separator)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleField, priceField, artImageView, contentView) { (nameField, priceField, artImageView, contentView) in
            
            nameField.top == contentView.top
            nameField.width == contentView.width/2
            nameField.height == 45
            
            priceField.top == nameField.bottom
            priceField.width == nameField.width
            priceField.height == 45
            
            artImageView.right == contentView.right - 20
            artImageView.height == contentView.height - 10
            artImageView.centerY == contentView.centerY
            artImageView.width == 70
        }
        
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 15, y: 45, width: bounds.width/2, height: height)
    }
    
    @objc func imageViewTapped() {
//        let vc = AddImageVC()
//        vc.imageView.image = self.artImageView.image
//        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configure(img: UIImage) {
        artImageView.image = img
    }

    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}
