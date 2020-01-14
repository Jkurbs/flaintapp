//
//  AddImageVC.swift
//  Flaint
//
//  Created by Kerby Jean on 6/27/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Vision
import CoreML
import ImageIO
import Cartography
import FirebaseStorage
import SafariServices

class AddImageVC: UIViewController {
    
    var userId: String?
    
    // MARK: - UI Elements
     
    var imageView = UIImageView()
    var addImgButton = UIButton()
    var button = UIButton()
    var editView: LyEditImageView!
    var cropButton: UIButton!
    var ref: StorageReference!
    var prediction: String?
    var classifications = [String]()
    var imagePicker: ImagePicker!
    
    // MARK: - Image Classification

//    lazy var classificationRequest: VNCoreMLRequest = {
//
//        do {
//            let model = try VNCoreMLModel(for: Art(key: <#String#>).model)
//            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//                self?.processClassifications(for: request, error: error)
//            })
//            request.imageCropAndScaleOption = .centerCrop
//            return request
//        } catch  {
//            fatalError("Failed to load Vision ML Model:\(error)")
//        }
//
//    }()
    
     // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(imageView, button, addImgButton, view) { (imageView, button, addImgButton, view) in
            
            imageView.width == view.width
            imageView.height == view.width
            imageView.center == view.center

            addImgButton.width == 100
            addImgButton.height == 100
            addImgButton.center == view.center
            
            button.top == imageView.bottom + 100
            button.width == view.width
        }
    }
    
    // MARK: - SetupView
    
    func setupView() {
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        view.backgroundColor = .backgroundColor
        self.title = "Add Painting"
        
//        self.navigationController?.isToolbarHidden = true
//        self.navigationController?.toolbar.tintColor = .darkText
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let rightButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
        rightButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightButton
        
        imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: false)
        
        cropButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cropButton.setImage(UIImage(named: "crop-30"), for: .normal)
        cropButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        addImgButton.setImage(UIImage(named: "Add-100"), for: .normal)
        addImgButton.addTarget(self, action: #selector(photoLibrary(_:)), for: .touchUpInside)
        view.addSubview(addImgButton)
        
//        button.setTitle("Learn more about creating a gallery.", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        button.setTitleColor(view.tintColor, for: .normal)
//        button.contentVerticalAlignment = .center
//        button.addTarget(self, action: #selector(learnmore), for: .touchUpInside)
//        view.addSubview(button)
        
        editView = LyEditImageView(frame: self.view.frame)
        editView.alpha = 0.0
        view.addSubview(editView)
        
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelCrop)))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneCrop)))
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        self.toolbarItems = items
    }
}

extension AddImageVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if (image != nil) {
//            self.updateClassifications(for: image!)
            self.navigationItem.titleView = self.cropButton
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.imageView.layer.zPosition = 1
            self.imageView.image = image
            self.editView.initWithImage(image: image!)
        }
    }
    
    @objc func learnmore() {
        let svc = SFSafariViewController(url: URL(string: "https://flaintapp.com")!)
        present(svc, animated: true, completion: nil)
    }
}
