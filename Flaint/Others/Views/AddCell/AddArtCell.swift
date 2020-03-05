//
//  AddArtCell.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import UIKit
import SceneKit
import Cartography

class AddArtCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var addButton = UIButton()
    
    var scnView: SCNView!
    var artRoomScene = ArtRoomScene(create: true)
    var viewController: UIViewController! 
    
    //HANDLE PAN CAMERA
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    var maxWidthRatioRight: Float = 0.2
    var maxWidthRatioLeft: Float = -0.2
    var maxHeightRatioXDown: Float = 0.02
    var maxHeightRatioXUp: Float = 0.4
    var lastFingersNumber = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .backgroundColor
        
        addButton.setImage(UIImage(named: "Add-100"), for: .normal)
        addButton.addTarget(self, action: #selector(photoLibrary), for: .touchUpInside)
        contentView.addSubview(addButton)
        
        scnView = SCNView()


        weak var weakSelf = self
        let strongSelf = weakSelf!

        scnView = strongSelf.scnView!
        let scene = artRoomScene
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.isJitteringEnabled = true
        scnView.backgroundColor = .backgroundColor
//        contentView.addSubview(scnView)
//        scnView.isHidden = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognize:)))
        panGesture.delegate = self
        scnView.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        constrain(addButton, contentView) { (addButton, contentView) in
            addButton.center == contentView.center
            addButton.width == 100
            addButton.height == 100
        }
        
        DispatchQueue.main.async {
            self.addButton.layer.cornerRadius = self.addButton.frame.size.width/2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.viewController.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as! UIImage
        addButton.removeFromSuperview()
        DispatchQueue.main.async {
            self.configure(image: image)
        }
    }
    
    func configure(image: UIImage) {

        contentView.addSubview(scnView)
        scnView.frame = contentView.bounds
        
        var desiredWidth = contentView.frame.width
        let desiredHeight = contentView.frame.height
        let imageHeight = (image.size.height)
        let imageWidth = (image.size.width)

        if imageHeight > desiredHeight && imageHeight < 1300 ||  imageWidth > desiredWidth && imageWidth < 400 {
            desiredWidth = desiredWidth * 0.8
        } else {
            desiredWidth = desiredWidth * 3.4
        }

//        artRoomScene.setup(artInfo: image, height: image.size.height / desiredWidth, width: image.size.width / desiredWidth, position: SCNVector3(0, 0.0, -1.5), rotation: SCNVector4(0,30,0,-56))
        
    }
    
    
    
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
            
            self.artRoomScene.boxnode.eulerAngles.y = Float(2 * Double.pi) * widthRatio
            
            //for final check on fingers number
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
        
        if (gestureRecognize.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = widthRatio
            lastHeightRatio = heightRatio
        }
    }
}
