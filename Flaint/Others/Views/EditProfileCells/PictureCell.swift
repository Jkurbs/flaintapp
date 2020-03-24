//
//  PictureCell.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    
    var userImgView = UIImageView()
    var addImgButton = UIButton()
    var imagePicker: ImagePicker!
    
    var item: AccountModelItem? {
        didSet {
            guard let item = item as? AccountViewModelGeneralItem else { return }
            guard item.imgUrl != "" else { return userImgView.image = UIImage(named: "Avatar") }
            
            print("IMAGE URL: \(item.imgUrl)")
            
            
            self.userImgView.sd_setImage(with:  URL(string: item.imgUrl), placeholderImage: UIImage(named: "Placeholder"))
        }
    }
    
    
    let separator: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return layer
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .backgroundColor
        
        userImgView.clipsToBounds = true
        userImgView.contentMode = .scaleAspectFill
        userImgView.layer.borderColor = UIColor.lightGray.cgColor
        userImgView.layer.borderWidth = 0.5
        userImgView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userImgView)
        
        addImgButton.setTitleColor(contentView.tintColor, for: .normal)
        addImgButton.setTitle("Change Picture", for: .normal)
        addImgButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addImgButton.contentHorizontalAlignment = .center
        addImgButton.translatesAutoresizingMaskIntoConstraints = false
        addImgButton.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
        contentView.addSubview(addImgButton)
        contentView.addSubview(separator)
    }
    
    @objc func pickImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            userImgView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 70),
            userImgView.widthAnchor.constraint(equalTo: userImgView.heightAnchor),
            userImgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            addImgButton.topAnchor.constraint(equalTo: userImgView.bottomAnchor, constant: 8.0),
            addImgButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        DispatchQueue.main.async {
            self.userImgView.layer.cornerRadius = self.userImgView.frame.width/2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PictureCell: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if (image != nil) {
            self.userImgView.image = image
        }
    }
}
