//
//  EmbeddedCollectionViewCell.swift
//  Flaint
//
//  Created by Kerby Jean on 5/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

final class EmbeddedCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.backgroundColor = .backgroundColor
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
