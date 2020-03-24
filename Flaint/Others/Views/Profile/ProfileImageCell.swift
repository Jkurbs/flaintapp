//
//  ProfileImageCell.swift
//  Flaint
//
//  Created by Kerby Jean on 4/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import SceneKit
import SDWebImage
import MaterialComponents.MaterialActivityIndicator

class ProfileImageCell: UICollectionViewCell {
    
    var imageView =  UIImageView()
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var item: AccountModelItem? {
        didSet {
            //            guard let item = item as? AccountViewModelGeneralItem else {
            //                return
            //            }
            //            profileImageView.sd_setImage(with: URL(string: item.pictureUrl), placeholderImage: UIImage(named: "profile"))
        }
    }
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UICreator.create.imageView(nil, contentView)        
    }
    
    required init(coder aDecoder: NSCoder) {super.init(coder: aDecoder)!}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        constrain(imageView, contentView) {(imageView, contentView) in
//            imageView.center == contentView.center
//            imageView.width == 80
//            imageView.height == 80
//        }
        
        
        DispatchQueue.main.async {
            self.imageView.clipsToBounds = true
            self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        }
    }
}

class DetailsCell: UICollectionViewCell {
    
    var label =  UILabel()
    var artCountLabel = UILabel()
    var quoteLabel = UILabel()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        label = UICreator.create.label("", 17, .darkText, .center, .regular, contentView)
        artCountLabel = UICreator.create.label("", 17, .darkText, .center, .regular, contentView)
        quoteLabel = UICreator.create.label("", 17, .darkText, .center, .semibold, contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        constrain(label, artCountLabel, quoteLabel, contentView) {(label, artCountLabel, quoteLabel, contentView) in
//
//            label.center == contentView.center
//            label.width == contentView.width
//            label.height == contentView.height - 20
//
//            artCountLabel.top == label.bottom
//            artCountLabel.width == contentView.width
//
//            quoteLabel.top == artCountLabel.bottom
//            quoteLabel.width == contentView.width
//        }
    }
}

class ProfileArtCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    // MARK: - UI Elements
    
    lazy var activityIndicator = MDCActivityIndicator()
    lazy var scnView = SCNView()
    lazy var artRoomScene = ArtRoomScene(create: true)
    var artImg: UIImage!
    var imageView = UIImageView()
    
    var lastWidthRatio: Float = 0
    let lastHeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    let maxWidthRatioRight: Float = 0.1
    let maxWidthRatioLeft: Float = -0.1
    var lastFingersNumber = 0
    let queue = OperationQueue()
    
    var art: Art? {
        didSet {
            guard let art = art else { return }
            guard let url = URL(string: art.imgUrl) else {return}

            let myBlock: SDExternalCompletionBlock! = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageUrl: URL?) -> Void in
                if let img = image {
                    /// Scale image to contentWidth
                    let width = self?.contentView.frame.width
                    let height = self?.contentView.frame.height
                    self?.queue.name = "com.Kurbs.Flaintartist.ImageResizing"
                    let imageResizeOperation = ImageResizeOperation(image: img, width: width!, height: height!)
                    let updateImageOperation = BlockOperation { [weak self] in
                        
                        self?.activityIndicator.isHidden = true
                        
                        let newImage = imageResizeOperation.image
                        
                        self?.artRoomScene.setup(image: img, height: newImage.size.height, width: newImage.size.width , position: SCNVector3(0, 0.0, -1.5), rotation: SCNVector4(0,0,0,0))
                    }
                    
                    updateImageOperation.addDependency(imageResizeOperation)
                    self?.queue.addOperation(imageResizeOperation)
                    OperationQueue.main.addOperation(updateImageOperation)
                }
            }
            self.imageView.sd_setImage(with: url, placeholderImage: nil , options: .continueInBackground, completed: myBlock)
        }
    }
    
    //MARK: - Initializer
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)!}
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        
        activityIndicator.frame = contentView.frame
        activityIndicator.cycleColors = [.darkText]
        activityIndicator.startAnimating()
        
        scnView = SCNView(frame: contentView.frame)
        
        weak var weakSelf = self

        scnView = weakSelf!.scnView
        let scene = artRoomScene
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.isJitteringEnabled = true
        scnView.backgroundColor = .backgroundColor
        scnView.antialiasingMode = .multisampling4X
        
        contentView.addSubview(scnView)        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        panGesture.delegate = self
        scnView.addGestureRecognizer(panGesture)
        contentView.addSubview(activityIndicator)
        
    }
    
    
    // MARK: - Actions
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let view = sender.view!
        let numberOfTouches = sender.numberOfTouches
        let translation = sender.translation(in: view)
                
        var widthRatio = (Float(translation.x) / (Float(view.frame.size.width)) - lastWidthRatio)
        
        if (numberOfTouches == fingersNeededToPan) {
            
            if(widthRatio >= maxWidthRatioRight) {
                widthRatio = maxWidthRatioRight
            }
            if(widthRatio <= maxWidthRatioLeft) {
                widthRatio = maxWidthRatioLeft
            }
            
            self.artRoomScene.boxnode.eulerAngles.y = (Float(2 * Double.pi) * (widthRatio)) 
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
    
        if sender.state == .ended && lastFingersNumber == fingersNeededToPan {
            lastWidthRatio = widthRatio
        }
    }
    
    override func prepareForReuse() {
        queue.cancelAllOperations()
        artRoomScene.rootNode.cleanUp()
    }
}

class ProfileArtInfoCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    let styleTitleLabel = UILabel()
    let styleLabel = UILabel()
    let sizeTitleLabel = UILabel()
    let sizeLabel = UILabel()
    
    let aboutTitleLabel = UILabel()
    let aboutLabel = UITextView()
    
    let dateTitleLabel = UILabel()
    let dateLabel = UILabel()
    
    let learnMoreButton = UIButton()
    var learnMoreLabel = UILabel()
    
    var art: Art? {
        didSet {
            updateViews()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    func setupViews() {
        contentView.backgroundColor = .backgroundColor
        
        let font = UIFont.medium
        let regularFont = UIFont.normal
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
 
        styleTitleLabel.font = font
        styleTitleLabel.text = "Style"
        styleTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        styleLabel.font = regularFont
        styleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sizeTitleLabel.font = font
        sizeTitleLabel.text = "Size"
        sizeTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        sizeLabel.font = regularFont
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateTitleLabel.font = font
        dateTitleLabel.text = "Date"
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        learnMoreLabel.text = "Learn more"
        learnMoreLabel.font = font
        learnMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        learnMoreButton.setImage(UIImage(named:"More-20"), for: .normal)
        learnMoreLabel.isUserInteractionEnabled = true
        learnMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = regularFont
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(styleTitleLabel)
        contentView.addSubview(styleLabel)
        contentView.addSubview(sizeTitleLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(dateTitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(learnMoreLabel)
        contentView.addSubview(learnMoreButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            
            styleTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            styleTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0.0),
            styleLabel.leftAnchor.constraint(equalTo: styleTitleLabel.rightAnchor, constant: 80.0),
            styleLabel.topAnchor.constraint(equalTo: styleTitleLabel.topAnchor),

            sizeTitleLabel.topAnchor.constraint(equalTo: styleLabel.bottomAnchor, constant: 8.0),
            sizeTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            sizeLabel.topAnchor.constraint(equalTo: styleLabel.bottomAnchor, constant: 8.0),
            sizeLabel.leftAnchor.constraint(equalTo: styleLabel.leftAnchor, constant: 0.0),
            
            dateTitleLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8.0),
            dateTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            dateLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8.0),
            dateLabel.leftAnchor.constraint(equalTo: sizeLabel.leftAnchor),
            
            learnMoreLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 8.0),
            learnMoreLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),

            learnMoreButton.topAnchor.constraint(equalTo: learnMoreLabel.topAnchor),
            learnMoreButton.leftAnchor.constraint(equalTo: learnMoreLabel.rightAnchor),
            learnMoreButton.centerYAnchor.constraint(equalTo: learnMoreLabel.centerYAnchor),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 25),
            learnMoreButton.widthAnchor.constraint(equalToConstant: 25)
        
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateViews() {
        guard let art = art else { return }
        titleLabel.text = art.title.capitalized
        titleLabel.sizeToFit()
        styleLabel.text = art.style ?? "Unkown"
        sizeLabel.text = "\(art.width ?? "") cm x \(art.height ?? "") cm"
        dateLabel.text = "\(art.date ?? "")"
    }
}

class ProfileArtAboutCell: UICollectionViewCell {
    
    var aboutTitleLabel = UILabel()
    var aboutLabel = UILabel()
    var moreButton = UIButton()
    
    fileprivate static let insets = UIEdgeInsets(top: 25, left: 15, bottom: 10, right: 15)
    fileprivate static let font = UIFont.normal
    
    static var singleLineHeight: CGFloat {
        return font.lineHeight + insets.top + insets.bottom
    }
    
    static func textHeight(_ text: String, width: CGFloat) -> CGFloat {
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [ NSAttributedString.Key.font: font ]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        return ceil(bounds.height) + insets.top + insets.bottom
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .backgroundColor
        
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        aboutTitleLabel.font = font
        aboutTitleLabel.text = "About this piece"
        
        aboutLabel.isHidden = true
        aboutLabel.numberOfLines = 5
        aboutLabel.adjustsFontSizeToFitWidth = true
        
        let attrs = [
            NSAttributedString.Key.font : UIFont.normal,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"Show more", attributes:attrs)
        attributedString.append(buttonTitleStr)
        moreButton.setAttributedTitle(attributedString, for: .normal)
        moreButton.isUserInteractionEnabled = false
        
        contentView.addSubview(aboutTitleLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(aboutLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        aboutTitleLabel.frame = CGRect(x: 15, y: 6, width: 0, height: 0)
        aboutTitleLabel.sizeToFit()
        
        moreButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        moreButton.sizeToFit()
        moreButton.layer.position.x = aboutTitleLabel.frame.size.width + (moreButton.frame.size.width + 25)
        aboutLabel.frame = contentView.bounds.inset(by: ProfileArtAboutCell.insets)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        aboutTitleLabel.text = "About this piece"
        aboutLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy"
    }
}
