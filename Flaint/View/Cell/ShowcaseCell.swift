//
//  ShowcaseCell.swift
//  Flaint
//
//  Created by Kerby Jean on 2017-07-04.
//  Copyright © 2017 Flaint, Inc. All rights reserved.
//

import UIKit
import SceneKit
import SDWebImage

class ShowcaseCell: UICollectionViewCell {
    
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var art: Art?
    var showcaseScene = ShowcaseScene(create: true)
    var artImageView = UIImageView()
    var panGesture = UIPanGestureRecognizer()
    
    //HANDLE PAN CAMERA
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    var maxWidthRatioRight: Float = 0.2
    var maxWidthRatioLeft: Float = -0.2
    var maxHeightRatioXDown: Float = 0.02
    var maxHeightRatioXUp: Float = 0.4
    var lastFingersNumber = 0
    
    
    
    override func awakeFromNib() {
        weak var weakSelf = self
        let strongSelf = weakSelf!
        sceneView = strongSelf.sceneView!
        let scene = showcaseScene
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.isJitteringEnabled = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognize:)))
        sceneView.addGestureRecognizer(panGesture)
    }
        
    func configureCell(forArt: Art) {
        
       self.art = forArt
        indicator.startAnimating()
        let myBlock: SDWebImageCompletionBlock! = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageUrl: URL?) -> Void in
            if let img = image {
                let height = img.size.height
                let width = img.size.width
                
                if height < 600 || width < 600 {
                    self?.showcaseScene.setup(artInfo: img, height: img.size.height / 200, width: img.size.width / 200, position: SCNVector3(0, 0.4, -1.5), rotation: SCNVector4(0,60,0,-56))
                } else if height == 600 || width == 600  {
                    self?.showcaseScene.setup(artInfo: img, height: img.size.height / 200, width: img.size.width / 200, position: SCNVector3(0, 0.4, -1.5), rotation: SCNVector4(0,60,0,-56))
                } else if height > 600 || width > 600  {
                    self?.showcaseScene.setup(artInfo: img, height: img.size.height / 500, width: img.size.width / 500, position: SCNVector3(0, 0.4, -1.5), rotation: SCNVector4(0,60,0,-56))
                }
                self?.indicator.stopAnimating()
            }
        }
        self.artImageView.sd_setImage(with: URL(string: self.art!.imgUrl) , placeholderImage: nil , options: .continueInBackground, completed: myBlock)
    }
    
    // MARK: - Gestures
    
    @objc func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        let numberOfTouches = gestureRecognize.numberOfTouches
        let translation = gestureRecognize.translation(in: gestureRecognize.view!)
        var widthRatio = Float(translation.x) / Float(gestureRecognize.view!.frame.size.width) - lastWidthRatio
        var heightRatio = Float(translation.y) / Float(gestureRecognize.view!.frame.size.height) - lastHeightRatio
        
        if (numberOfTouches == fingersNeededToPan) {
            //  HEIGHT constraints
            if (heightRatio >= maxHeightRatioXUp ) {
                heightRatio = maxHeightRatioXUp
            }
            
            if (heightRatio <= maxHeightRatioXDown ) {
                heightRatio = maxHeightRatioXDown
            }
            
            //  WIDTH constraints
            if(widthRatio >= maxWidthRatioRight) {
                widthRatio = maxWidthRatioRight
            }
            if(widthRatio <= maxWidthRatioLeft) {
                widthRatio = maxWidthRatioLeft
            }
            
            self.showcaseScene.boxnode.eulerAngles.y = Float(2 * Double.pi) * widthRatio
            
            //for final check on fingers number
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
        
        if (gestureRecognize.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = widthRatio
            lastHeightRatio = heightRatio
        }
        
        if gestureRecognize.state == .began ||  gestureRecognize.state == .changed {
           // NotificationCenter.default.post(name: editNotif, object: self)
        } else if gestureRecognize.state == .cancelled || gestureRecognize.state == .ended {
           // NotificationCenter.default.post(name: cancelNotif, object: self)
        }
    }
}
