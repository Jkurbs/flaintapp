//
//  ReorderCell.swift
//  Flaint
//
//  Created by Kerby Jean on 3/31/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage

class ReorderCell: UITableViewCell {
    
    var artImageView: UIImageView!
    var titleLabel: UILabel!
    var positionLabel: UILabel!
    
    var art: Art? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        artImageView = UICreator.create.imageView(nil, self.contentView)
        artImageView.contentMode = .scaleAspectFit
        titleLabel = UICreator.create.label("", 15, .label, .natural, .medium, self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            artImageView.widthAnchor.constraint(equalToConstant: 46.0),
            artImageView.heightAnchor.constraint(equalToConstant: 46.0),
            artImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0),
            artImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: artImageView.rightAnchor, constant: 8.0),
            titleLabel.centerYAnchor.constraint(equalTo: artImageView.centerYAnchor)
        ])
    }
    
    func updateViews() {
        guard let art = art else { return }
        if let url = art.imgUrl {
            artImageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        titleLabel.text = art.title
    }
}
