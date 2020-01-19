//
//  ProfileImageCell.swift
//  Flaint
//
//  Created by Kerby Jean on 4/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import Cartography
import Hero
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
        
        constrain(imageView, contentView) {(imageView, contentView) in
            imageView.center == contentView.center
            imageView.width == 80
            imageView.height == 80
        }
        
        
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
        
        constrain(label, artCountLabel, quoteLabel, contentView) {(label, artCountLabel, quoteLabel, contentView) in
            
            label.center == contentView.center
            label.width == contentView.width
            label.height == contentView.height - 20
            
            artCountLabel.top == label.bottom
            artCountLabel.width == contentView.width

            quoteLabel.top == artCountLabel.bottom
            quoteLabel.width == contentView.width
        }
    }
}

import func AVFoundation.AVMakeRect


class ProfileArtCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    

    // MARK: - UI Elements
    
    lazy var activityIndicator = MDCActivityIndicator()
    lazy var scnView = SCNView()
    lazy var artRoomScene = ArtRoomScene(create: true)
    var spriteScene: OverlayScene!
    var artImg: UIImage!
    var imageView = UIImageView()

    // MARK: - Pan Gesture values
    
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    var maxWidthRatioRight: Float = 0.1
    var maxWidthRatioLeft: Float = -0.1
    var lastFingersNumber = 0
    
    var desiredWidth: CGFloat = 0.0
    var desiredHeight: CGFloat = 0.0
    
    var art: Art? {
        didSet {
            guard let art = art else { return }
            guard let url = URL(string: art.imgUrl) else {return}
            
            let myBlock: SDExternalCompletionBlock! = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageUrl: URL?) -> Void in
                if let img = image {
                    /// Scale image to contentWidth
                    let width = (self?.contentView.frame.width)!
                    let newImage = self?.resizeImage(with: img, scaledToWidth: Float(width))
                    self?.spriteScene.configureImg(image: newImage!)

                    self!.activityIndicator.isHidden = true
                     self?.artRoomScene.setup(artInfo: img, height: newImage!.size.height, width: newImage!.size.width , position: SCNVector3(0, 0.0, -1.5), rotation: SCNVector4(0,0,0,0))
                }
            }
            DispatchQueue.global(qos: .background).async {
                self.imageView.sd_setImage(with: url, placeholderImage: nil , options: .continueInBackground, completed: myBlock)
            }
        }
    }
    
    //MARK: - Initializer
        
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)!}
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        
        desiredWidth = contentView.frame.width
        desiredHeight = contentView.frame.height
        
        activityIndicator.frame = contentView.frame
        activityIndicator.cycleColors = [.darkText]
        activityIndicator.startAnimating()
       
        scnView = SCNView(frame: contentView.frame)
        
        weak var weakSelf = self
        let strongSelf = weakSelf!
        
        spriteScene = OverlayScene(size: self.frame.size)
        spriteScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteScene.backgroundColor = .red

        scnView = strongSelf.scnView
        let scene = artRoomScene
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.isJitteringEnabled = true
        scnView.backgroundColor = .backgroundColor
        scnView.antialiasingMode = .multisampling4X
        scnView.showsStatistics = true
//        scnView.overlaySKScene = spriteScene
     
        contentView.addSubview(scnView)        
 
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        panGesture.delegate = self
        scnView.addGestureRecognizer(panGesture)

        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        
//        self.spriteScene.startAnimation()
        contentView.addSubview(activityIndicator)

    }
    

    //MARK: - Scale image
    
     func resizeImage(with sourceImage: UIImage?, scaledToWidth i_width: Float) -> UIImage? {
        let oldWidth = Float(sourceImage?.size.width ?? 0.0)
        var diff: Float = 0
        let scaleFactor = i_width / oldWidth
        
        let newHeight = Float((sourceImage?.size.height ?? 0.0) * CGFloat(scaleFactor))
        let contentViewHeight = Float(self.contentView.frame.size.height)
        if newHeight > contentViewHeight {
            diff = Float(newHeight - contentViewHeight) + 20
        }
        
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth - diff), height: CGFloat(newHeight - diff)))
        sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth - diff), height: CGFloat(newHeight - diff)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    //MARK: - Pan Gesture
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        var initialLocation: CGPoint?
        let view = sender.view!
        let numberOfTouches = sender.numberOfTouches
        let translation = sender.translation(in: view)
        var widthRatio = Float(translation.x) / Float(view.frame.size.width) - lastWidthRatio
        
        let xVelocity = sender.velocity(in: view ).x / 60
        
        if (numberOfTouches == fingersNeededToPan) {
            //  WIDTH constraints
            if(widthRatio >= maxWidthRatioRight) {
                widthRatio = maxWidthRatioRight
            }
            if(widthRatio <= maxWidthRatioLeft) {
                widthRatio = maxWidthRatioLeft
            }
            
//            initialLocation?.x = (initialLocation ?? 0)
//
//            (initialLocation.x)! = (initialLocation.x)! + (sender.velocity(in: colorSlider!).x / 60)
//
//
//
            self.artRoomScene.boxnode.eulerAngles.y = Float(2 * Double.pi) * widthRatio
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
        
        if (sender.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = widthRatio
        }
    }
}

class ProfileArtInfoCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    
    var styleTitleLabel = UILabel()
    var styleLabel = UILabel()
    var sizeTitleLabel = UILabel()
    var sizeLabel = UILabel()
    
    var aboutTitleLabel = UILabel()
    var aboutLabel = UITextView()
    
    
    var dateTitleLabel = UILabel()
    var dateLabel = UILabel()
        
    var learnMoreButton = UIButton()
    var learnMoreLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .backgroundColor
        
        let font = UIFont.medium
        let regularFont = UIFont.normal
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.hero.id = "test"
        
        styleTitleLabel.font = font
        styleTitleLabel.text = "Style"
        
        styleLabel.font = regularFont
        
        sizeTitleLabel.font = font
        sizeTitleLabel.text = "Size"
        
        sizeLabel.font = regularFont

        dateTitleLabel.font = font
        dateTitleLabel.text = "Date"
        
        learnMoreLabel.text = "Learn more"
        learnMoreLabel.font = font
        
        learnMoreButton.setImage(UIImage(named:"More-20"), for: .normal)
        learnMoreLabel.isUserInteractionEnabled = true
        
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
        
        constrain(titleLabel, styleTitleLabel, styleLabel, sizeTitleLabel, sizeLabel, dateTitleLabel, dateLabel, contentView) { (titleLabel, styleTitleLabel, styleLabel, sizeTitleLabel, sizeLabel, dateTitleLabel, dateLabel, contentView) in
              
              titleLabel.top == contentView.top
              titleLabel.left == contentView.left + 15
              
              styleTitleLabel.top == titleLabel.bottom + 10
              styleTitleLabel.left == titleLabel.left
              
              styleLabel.left == styleTitleLabel.right + 80
              styleLabel.top == styleTitleLabel.top
              
              sizeTitleLabel.top == styleLabel.bottom + 10
              sizeTitleLabel.left == titleLabel.left
              
              sizeLabel.left == styleLabel.left
              sizeLabel.top == styleLabel.bottom + 10
              
              dateTitleLabel.top == sizeLabel.bottom + 10
              dateTitleLabel.left == titleLabel.left
              
              dateLabel.left == sizeLabel.left
              dateLabel.top == sizeLabel.bottom + 10
          }
          
          constrain(learnMoreLabel, learnMoreButton, dateTitleLabel, contentView) { (learnMoreLabel, learnMoreButton, dateTitleLabel, contentView) in
              
              learnMoreLabel.top == dateTitleLabel.bottom + 5
              learnMoreLabel.left == contentView.left + 15
              
              learnMoreButton.top == learnMoreLabel.top
              learnMoreButton.left == learnMoreLabel.right
              learnMoreButton.height == 20
              learnMoreButton.width == 20
              learnMoreButton.centerY == learnMoreLabel.centerY
          }
    }

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
  
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ art: Art) {
        titleLabel.text = art.title.capitalized
        titleLabel.sizeToFit()
        styleLabel.text = art.style ?? "Unkown"
        sizeLabel.text = "\(art.width ?? "")cm x \(art.height ?? "")cm"
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
