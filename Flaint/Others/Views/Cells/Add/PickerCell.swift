//
//  PickerCell.swift
//  Flaint
//
//  Created by Kerby Jean on 4/26/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit

class PickerCell: AUPickerCell, AUPickerCellDelegate {
    
    var selectedValue: String?
    
    override init(type: AUPickerCell.PickerType, reuseIdentifier: String?) {
        super.init(type: type, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tertiarySystemBackground
        
        separatorInset = UIEdgeInsets.zero
        leftLabel.textColor = UIColor.label
        rightLabel.textColor = UIColor.secondaryLabel
        leftLabel.font = UIFont.systemFont(ofSize: 15)
        rightLabel.font = UIFont.systemFont(ofSize: 15)
        separatorHeight = 1
        unexpandedHeight = 50
        selectionStyle = .none
        delegate = self 
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any) {
        
    }
}
