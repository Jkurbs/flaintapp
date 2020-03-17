//
//  EditArtCell.swift
//  Flaint
//
//  Created by Kerby Jean on 5/13/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import SceneKit
import Cartography
import SDWebImage

class EditArtCell: UITableViewCell {
    
    var artImageView = UIImageView()
    var artImg: UIImage?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundColor
        artImageView.contentMode = .scaleAspectFit
        contentView.addSubview(artImageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = contentView.frame.size.width - 75
        let height = contentView.frame.size.height - 75
        artImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        artImageView.center = contentView.center
    }
    
    var item: LearnModelItem? {
        didSet {
            guard let item = item as? LearnViewModelGeneralItem else {
                return
            }
            artImageView.sd_setImage(with: URL(string: item.imgUrl), completed: nil)
        }
    }
    
    func configure(imgUrl: String?) {
        artImageView.sd_setImage(with: URL(string: imgUrl ?? ""), completed: nil)
    }
}

class InfoTextFieldCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.clearButtonMode = .always
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 0, width: 90, height: contentView.frame.height)
        textField.frame = CGRect(x: titleLabel.layer.position.x + 20, y: 0, width: contentView.frame.size.width - 90, height:  contentView.frame.height)
    }
    
    func configure(title: String, art: Art?)  {
        titleLabel.text = title
        textField.placeholder = title
        switch title {
        case "Title":
            textField.text = art?.title
        case "Price":
            textField.text = "$\(art?.price ?? "")"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        default:
            print("default")
        }
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

