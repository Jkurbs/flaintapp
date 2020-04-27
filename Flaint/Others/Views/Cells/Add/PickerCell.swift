//
//  PickerCell.swift
//  Flaint
//
//  Created by Kerby Jean on 4/26/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {
    
    var pickerView = UIPickerView()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The label on the right side of the cell that displays the currently selected value in the picker view.
    let rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isPickerVisible = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var values = [Any]()
    
    func showPickerView() {
        isPickerVisible = true
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        self.pickerView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.alpha = 1.0
        }) { (finished) in
            self.pickerView.isHidden = false
        }
    }
    
    func hidePickerView() {
        isPickerVisible = false
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.alpha = 0.0
        }) { (finished) in
            self.pickerView.isHidden = true
        }
    }
    
    func updateViews(_ leftText: String, _ rightText: String?, values: [String]) {
        leftLabel.text = leftText
        rightLabel.text = rightText
        self.values = values
        pickerView.reloadAllComponents()
        if let index = values.firstIndex(of: rightText ?? "") {
            print("INDEX: \(index)")
            pickerView.selectedRow(inComponent: index)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0),
            leftLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0),
            rightLabel.heightAnchor.constraint(equalTo: leftLabel.heightAnchor)
        ])
    }
}

extension PickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}
