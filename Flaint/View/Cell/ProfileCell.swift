//
//  ProfileCell.swift
//  Flaint
//
//  Created by Kerby Jean on 2017-07-04.
//  Copyright © 2017 Flaint, Inc. All rights reserved.
//

import UIKit
import ChameleonFramework

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 15
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureCell() {
        let color = UIColor(averageColorFrom: imageView.image)
        headerLabel.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true, alpha: 1.0)
    }
    
    
}
