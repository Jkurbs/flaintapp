//
//  ArNotSupporterVC.swift
//  Flaint
//
//  Created by Kerby Jean on 6/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class ArNotSupporterVC: UIViewController {
    
    var rotateButton: UIButton!
    var cameraButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Virtual riality is not supported on this device"
        label.sizeToFit()
        
        label.center = view.center
        view.addSubview(label)
        
        cameraButton = UIButton(frame: CGRect(x: 0, y: label.layer.position.y + 40, width:  view.frame.width, height: 0))
        cameraButton.setTitle("Experience 2d instead", for: .normal)
        cameraButton.contentHorizontalAlignment = .center
        cameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cameraButton.setTitleColor(view.tintColor, for: .normal)
//        view.addSubview(cameraButton)
        
        var items = [UIBarButtonItem]()
        
        self.rotateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.rotateButton.setImage(UIImage(named: "Rotation-30")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        self.rotateButton.tintColor = .white
        self.rotateButton.addTarget(self, action: #selector(rotate), for: .touchUpInside)
        let rotateButton = UIBarButtonItem(customView: self.rotateButton)
        
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "More-30"), style: .done, target: self, action: #selector(rotate)))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Add-30"), style: .done, target: self, action: #selector(rotate)))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append( rotateButton)
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        self.toolbarItems = items
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barTintColor = .black
        self.navigationController?.toolbar.tintColor = .white
        self.navigationController?.toolbar.isTranslucent = true
        
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

    }
    
    @objc func rotate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.rotateButton.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
    }
}
