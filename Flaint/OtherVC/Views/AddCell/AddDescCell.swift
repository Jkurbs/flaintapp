//
//  AddDescCell.swift
//  Flaint
//
//  Created by Kerby Jean on 6/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography


class AddDescCell: UITableViewCell {
    
    var textView: UITextView!
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.text = "Description"
        textView.textColor = UIColor.lightGray
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(textView, contentView) { (textView, contentView) in
            textView.top == contentView.top + 5
            textView.bottom == contentView.bottom + 5
            textView.left == contentView.left + 12
            textView.right == contentView.right - 20
        }
    }
    
    var textString: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }
}

extension AddDescCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

            let size = textView.bounds.size
            let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
            if size.height != newSize.height {
                UIView.setAnimationsEnabled(false)
                tableView?.beginUpdates()
                tableView?.endUpdates()
                UIView.setAnimationsEnabled(true)
                
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.contentView.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}
