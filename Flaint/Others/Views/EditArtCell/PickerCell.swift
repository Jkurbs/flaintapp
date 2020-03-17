//
//  PickerCell.swift
//  Flaint
//
//  Created by Kerby Jean on 3/15/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation


class PickerCell: AUPickerCell {
    
    override init(type: PickerType, reuseIdentifier: String?) {
        super.init(type: type, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsets.zero
        self.leftLabel.textColor = UIColor.darkText
        self.rightLabel.textColor = UIColor.darkText
        self.leftLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.rightLabel.font = UIFont.systemFont(ofSize: 15)
        self.rightLabel.text = "cm"
        self.separatorHeight = 0.0
        self.unexpandedHeight = 40
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews() {
        
    }
}
