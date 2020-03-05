////
////  CustomSlider.swift
////  Flaint
////
////  Created by Kerby Jean on 5/5/19.
////  Copyright © 2019 Kerby Jean. All rights reserved.
////
//
//
import UIKit
import Shimmer
import Cartography
import CollectionPickerView


class CustomPicker: UIView {
    
    var pickerView: CollectionPickerView!
    var indicatorView = UIView()
    var rotationNumber = 50
    var shimmeringView = FBShimmeringView()
    var slideLabel = UILabel()
    
    var count = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .backgroundColor

        NotificationCenter.default.addObserver(self, selector: #selector(self.count(_:)), name: NSNotification.Name(rawValue: "count"), object: nil)
        
        indicatorView.backgroundColor = UIColor(red: 200.0/255.0, green: 201.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        pickerView = CollectionPickerView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectCenter = true
        pickerView.cellSpacing = 100
        pickerView.cellSize = 60
        pickerView.viewDepth = 3000
        pickerView.selectItem(at: rotationNumber/2)
        
        pickerView.collectionView.reloadData()
        pickerView.collectionView.register(TickCell.self, forCellWithReuseIdentifier: "cell")
        
        slideLabel.textAlignment = .center
        slideLabel.font = UIFont.systemFont(ofSize: 13)
        slideLabel.text = "Tap to view more"
        
        shimmeringView.contentView = slideLabel
        shimmeringView.isShimmering = true
        
        slideLabel.sizeToFit()
        slideLabel.textAlignment = .center
        slideLabel.textColor = .darkGray
        slideLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        slideLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(pickerView)
        self.addSubview(indicatorView)
        self.addSubview(shimmeringView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.frame.size.height - 35
        let width = self.frame.size.width
        pickerView.frame = CGRect(x: 0, y: 10 , width: self.frame.size.width, height: height)
        indicatorView.frame = CGRect(x: pickerView.frame.width/2, y: 0, width: 5, height: 5)
        indicatorView.layer.cornerRadius = self.indicatorView.frame.size.width/2
        shimmeringView.frame = CGRect(x: 0, y: self.bounds.size.height - 25, width: width , height: 20)
    }
    
    @objc func count(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let count = dict["count"] as? Int {
                self.count = count - 1
            }
        }
    }
}

extension CustomPicker: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rotationNumber
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TickCell
        cell.contentView.layer.cornerRadius = 2
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            UIView.animate(withDuration: 0.5) {
                self.pickerView.alpha = 1.0
                self.indicatorView.alpha = 1.0
                self.slideLabel.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.pickerView.alpha = 0.6
                self.indicatorView.alpha = 0.6
            }
        }
    }
    
    func setTimer() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] (timer) in
            UIView.animate(withDuration: 0.5) {
                self?.slideLabel.alpha = 1.0
            }
        }
    }
    
    func pickerTimer() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] (timer) in
            UIView.animate(withDuration: 0.5) {
                self?.slideLabel.alpha = 1.0
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        var index: [String: Int]
        let rotationNumber = self.rotationNumber/2
        let row = indexPath.row
        let diff = row - rotationNumber
        
        if  row > rotationNumber {
            index = ["index": diff]
        } else {
            index = ["index": diff]
        }
        
        if row < rotationNumber {
            collectionView.selectItem(at: IndexPath(row: rotationNumber, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            return
        } else if count < diff {
            collectionView.selectItem(at: IndexPath(row: rotationNumber + count, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            return
        }
  
        NotificationCenter.default.post(name: Notification.Name("slide"), object: nil, userInfo: index)
        UIView.animate(withDuration: 0.5, animations: {
        self.slideLabel.alpha = 0.0
        self.indicatorView.alpha = 1.0
        self.pickerView.alpha = 1.0
        }) { (done) in
            self.setTimer()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("DESELECTED")
    }
}


