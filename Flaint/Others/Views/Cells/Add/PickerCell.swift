//
//  PickerCell.swift
//  Flaint
//
//  Created by Kerby Jean on 4/26/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit

class PickerCell: AUPickerCell {
    
    var selectedValue: String?
    
    override init(type: AUPickerCell.PickerType, reuseIdentifier: String?) {
        super.init(type: type, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets.zero
        leftLabel.textColor = UIColor.label
        rightLabel.textColor = UIColor.secondaryLabel
        leftLabel.font = UIFont.systemFont(ofSize: 15)
        rightLabel.font = UIFont.systemFont(ofSize: 15)
        separatorHeight = 1
        unexpandedHeight = 50
        selectionStyle = .none
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
