//
//  ArtRoomScene.swift
//  Flaint
//
//  Created by Kerby Jean on 4/22/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import QuartzCore
import SceneKit

class ArtRoomScene: SCNScene {
    
    lazy var boxnode = SCNNode()
    
    convenience init(create: Bool) {
        self.init()
    }
    
    func setup(image: UIImage?, height: CGFloat? = nil, width: CGFloat? = nil, position: SCNVector3, rotation: SCNVector4)  {
        
       let camera = SCNCamera()
       var materials = [SCNMaterial]()
       let cameraOrbit = SCNNode()

        let geometry = SCNBox(width: width!/110, height: height!/110, length: 57 / 700, chamferRadius: 0.008)
        boxnode = SCNNode(geometry: geometry)
        boxnode.position = position
        boxnode.rotation = rotation
        
        self.rootNode.addChildNode(boxnode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        camera.orthographicScale = 9
        camera.zNear = 1
        camera.zFar = 90
        cameraOrbit.position = SCNVector3(0, 0, 3)
        
        cameraOrbit.addChildNode(cameraNode)
        self.rootNode.addChildNode(cameraOrbit)
        let material = SCNMaterial()
        material.diffuse.contents = image
        let borderMat = SCNMaterial()
        borderMat.diffuse.contents = UIImage(named: "texture")
        materials = [material, borderMat]
        geometry.materials = materials
    }
}


extension SCNNode {
    func cleanUp() {
        for child in childNodes {
            child.cleanUp()
        }
        geometry = nil
    }
}


