//
//  OverlayScene.swift
//  Flaint
//
//  Created by Kerby Jean on 6/6/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class OverlayScene: SKScene {
    
    var slideNode: SKShapeNode!
    var boxNode: SCNNode!
    var texture: SKTexture!
    var image = UIImage()
    var sprite: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let randomNumber = Int.random(in: currentCount / 2...currentCount)
        if currentCount == 1 || randomNumber == currentCount {
            configure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func didMove(to view: SKView) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinched(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    var previousScale = CGFloat(1.0)
    
    @objc func pinched(_ sender: UIPinchGestureRecognizer) {
//        if sender.scale > previousScale {
//            sprite.isHidden = false
//            previousScale = sender.scale
//            if sprite.size.height < 800 {
//                let zoomIn = SKAction.scale(by: 1.05, duration: 0)
//                sprite.run(zoomIn)
//            }
//        }
//        if sender.scale < previousScale {
//            previousScale = sender.scale
//            if sprite.size.height > 200 {
//                let zoomOut = SKAction.scale(by: 0.95, duration: 0)
//                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//                sprite.run(zoomOut)
//                sprite.run(fadeOut)
//            }
//        }
    }
    
    
    func configureImg(image: UIImage) {
        texture = SKTexture(image: image)
        texture.usesMipmaps = true
        sprite = SKSpriteNode(texture: texture)
        sprite.isHidden = true
        sprite.size = CGSize(width: image.size.width / 1.2, height: image.size.height / 1.2)
        self.addChild(sprite)
    }
    
    
    func configure() {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 25).cgPath
        slideNode = SKShapeNode(path: path, centered: true)
        
        slideNode.fillColor = UIColor(white: 0.7, alpha: 0.5)
        self.addChild(self.slideNode)
        startAnimation()
    }
    
    func startAnimation() {
        
        let xPosition = slideNode.position.x
        let yPosition = slideNode.position.y
        
        let fadeIn = SKAction.fadeAlpha(by: 0.5, duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let moveRight = SKAction.move(to: CGPoint(x: xPosition + 70, y: yPosition), duration: 0.5)
        let moveLeft = SKAction.move(to: CGPoint(x: xPosition - 70, y: yPosition), duration: 0.5)
        let moveCenter = SKAction.move(to: CGPoint(x: xPosition, y: yPosition), duration: 0.5)
        let actions = SKAction.sequence([fadeIn, moveRight, moveCenter, moveLeft, moveCenter, fadeOut])
        slideNode.run(actions) { [weak self] in
            self?.removeFromParent()
        }
    }
}
