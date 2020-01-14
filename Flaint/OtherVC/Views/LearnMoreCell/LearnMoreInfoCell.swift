//
//  LearnMoreInfoCell.swift
//  Flaint
//
//  Created by Kerby Jean on 6/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography

class LearnMoreInfoCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var valueLabel = UILabel()

    static var id: String {
        return String(describing: self)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .backgroundColor
        
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let regularFont = UIFont.systemFont(ofSize: 14)
        
        titleLabel.font = font
        
        valueLabel.font = regularFont
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(titleLabel, valueLabel, contentView) { (titleLabel, valueLabel, contentView) in
            titleLabel.left == contentView.left + 20
            titleLabel.height == contentView.height
            
            valueLabel.right == contentView.right + 20
            valueLabel.height == contentView.height
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text =  value
    }
}

class LearnMoreDescCell: UITableViewCell {
    
    var descLabel = UILabel()
    
    static var id: String {
        return String(describing: self)
    }
    
    fileprivate static let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    fileprivate static let font = UIFont.systemFont(ofSize: 14)
    
    
    static func textHeight(_ text: String, width: CGFloat) -> CGFloat {
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedString.Key.font: font ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        return ceil(bounds.height) + insets.top + insets.bottom
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .backgroundColor
        
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.numberOfLines = 0
        contentView.addSubview(descLabel)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descLabel.frame = contentView.bounds.inset(by: LearnMoreDescCell.insets)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ desc: String) {
        descLabel.text = desc
        descLabel.sizeToFit()
    }
}
