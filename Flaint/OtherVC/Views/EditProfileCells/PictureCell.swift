//
//  PictureCell.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import func AVFoundation.AVMakeRect


class PictureCell: UITableViewCell {
    
    var userImgView = UIImageView()
    var addImgButton = UIButton()
    var imagePicker: ImagePicker!
    
    static var id: String {
        return String(describing: self)
    }
    
    var item: AccountModelItem? {
        didSet {
            guard let item = item as? AccountViewModelGeneralItem else { return }
            guard item.imgUrl != "" else { return userImgView.image = UIImage(named: "Avatar") }
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
        contentView.addSubview(userImgView)
        
        addImgButton.setTitleColor(contentView.tintColor, for: .normal)
        addImgButton.setTitle("Change Picture", for: .normal)
        addImgButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addImgButton.contentHorizontalAlignment = .center
        addImgButton.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
        contentView.addSubview(addImgButton)
        contentView.addSubview(separator)
    }
    
    @objc func pickImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(userImgView, addImgButton, separator, contentView) { (userImgView, addImgButton, separator, contentView) in
            userImgView.height == contentView.height - 70
            userImgView.width == contentView.height - 70
            userImgView.center == contentView.center
            
            addImgButton.top == userImgView.bottom + 5
            addImgButton.width == contentView.width
            
            separator.right == contentView.right
            separator.height == 0.5
            separator.width == contentView.width
            separator.bottom == contentView.bottom
        }
        
        
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
