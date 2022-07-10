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
import FirebaseStorage

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
    
    var artsCount: Int?
    
    // MARK: - Image Classification
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for:  ImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            print(error)
            fatalError("Failed to load Vision ML Model:\(error)")
        }
    }()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addImgButton.widthAnchor.constraint(equalToConstant: 96.0),
            addImgButton.heightAnchor.constraint(equalToConstant: 96.0),
            addImgButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addImgButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - SetupView
    
    func setupView() {
        
        self.restorationIdentifier = UIView.id
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        view.backgroundColor = .systemBackground
        self.title = "Add Painting"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let rightButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
        rightButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightButton
        
        imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: false)
        
        let cropImageConfiguration = UIImage.SymbolConfiguration(scale: .default)
        var cropButtonImage = UIImage(systemName: "crop", withConfiguration: cropImageConfiguration)!
        cropButtonImage = cropButtonImage.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        cropButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cropButton.setImage(cropButtonImage, for: .normal)
        cropButton.addTarget(self, action: #selector(crop), for: .touchUpInside)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let plusImageConfiguration = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        var plusButtonImage = UIImage(systemName: "plus.circle", withConfiguration: plusImageConfiguration)!
        plusButtonImage = plusButtonImage.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        addImgButton.setImage(plusButtonImage, for: .normal)
        addImgButton.addTarget(self, action: #selector(photoLibrary(_:)), for: .touchUpInside)
        addImgButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addImgButton)
        
        
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
        if image != nil {
            //            self.updateClassifications(for: image!)
            self.navigationItem.titleView = self.cropButton
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.imageView.layer.zPosition = 1
            self.imageView.image = image
            self.editView.initWithImage(image: image!)
        }
    }
    
    @objc func learnmore() {
        //        let svc = SFSafariViewController(url: URL(string: "https://flaintapp.com")!)
        //        present(svc, animated: true, completion: nil)
    }
}
