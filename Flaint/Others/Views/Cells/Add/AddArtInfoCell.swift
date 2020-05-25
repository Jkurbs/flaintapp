//
//  AddArtInfoCell.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class AddArtInfoCell: UITableViewCell {
    
    var titleField = FieldRect()
    var priceField = FieldRect()
    var artImageView = UIImageView()
    
    var viewController: UIViewController!
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        
        backgroundColor = .tertiarySystemBackground
        
        let font = UIFont.systemFont(ofSize: 15)
        
        titleField.font = font
        titleField.clearButtonMode = .always
        titleField.setPlaceHolderColor("Name")
        titleField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleField)
        
        priceField.font = font
        priceField.clearButtonMode = .always
        priceField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        priceField.setPlaceHolderColor("Price")
        priceField.keyboardType = .numberPad
        priceField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceField)
        
        artImageView.contentMode = .scaleAspectFit
        artImageView.isUserInteractionEnabled = true
        artImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        artImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(artImageView)
        
        contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            artImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            artImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -8.0),
            artImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artImageView.widthAnchor.constraint(equalToConstant: 72.0),
            
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 45),
            separator.widthAnchor.constraint(equalTo: widthAnchor, constant: -120.0),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            titleField.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleField.widthAnchor.constraint(equalTo: separator.widthAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 48.0),
            
            priceField.topAnchor.constraint(equalTo: titleField.bottomAnchor),
            priceField.widthAnchor.constraint(equalTo: titleField.widthAnchor),
            priceField.heightAnchor.constraint(equalToConstant: 48.0),
        ])
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
