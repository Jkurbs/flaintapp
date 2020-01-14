//
//  AddPictureVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/23/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


import UIKit
import Hero
import Cartography
import SceneKit
import AVKit
import AVFoundation


let viewControllerIDs = ["first", "second", "third"]

class OnboardingVC: UIViewController, HeroViewControllerDelegate, UIGestureRecognizerDelegate {
    var panGR: UIPanGestureRecognizer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var primaryLabel: UILabel!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
    }
    
    func initializeVideoPlayerWithVideo(view: UIView) {
        
        let size = view.frame.size.width
        let videoView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        videoView.backgroundColor = .backgroundColor
        videoView.center = view.center
        
        view.addSubview(videoView)
        
        let videoString:String? = Bundle.main.path(forResource: "My Movie", ofType: "mp4")
        
        guard let unwrappedVideoPath = videoString else {return}
        
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        self.player = AVPlayer(url: videoUrl)
        player.isMuted = true 
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.backgroundColor.cgColor
        
        layer.frame = videoView.bounds
        
        layer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(layer)
        
        let coverView1 = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: view.frame.height))
        let coverView2 = UIView(frame: CGRect(x: view.frame.size.width - 50, y: 0, width: 50, height: view.frame.height))
        
        coverView1.backgroundColor = .backgroundColor
        coverView2.backgroundColor = .backgroundColor
        view.addSubview(coverView1)
        view.addSubview(coverView2)
        
        self.player.play()
        
    }
    
    enum TransitionState {
        case normal, slidingLeft, slidingRight
    }
    
    var state: TransitionState = .normal
    weak var nextVC: OnboardingVC?
    
    @objc func pan() {
        let translateX = panGR.translation(in: nil).x
        let velocityX = panGR.velocity(in: nil).x
        switch panGR.state {
        case .began, .changed:
            let nextState: TransitionState
            if state == .normal {
                nextState = velocityX < 0 ? .slidingLeft : .slidingRight
            } else {
                nextState = translateX < 0 ? .slidingLeft : .slidingRight
            }
            
            if nextState != state {
                Hero.shared.cancel(animate: false)
                let currentIndex = viewControllerIDs.firstIndex(of: self.title!)!
                let nextIndex = (currentIndex + (nextState == .slidingLeft ? 1 : viewControllerIDs.count - 1)) % viewControllerIDs.count
                nextVC = self.storyboard!.instantiateViewController(withIdentifier: viewControllerIDs[nextIndex]) as? OnboardingVC
                
                if nextVC?.title == "third" {
                    initializeVideoPlayerWithVideo(view: nextVC!.view)
                } else {
                    
                }
                
                if nextState == .slidingLeft {
                    //                    applyShrinkModifiers()
                    //                    nextVC!.applySlideModifiers()
                } else {
                    //                    applySlideModifiers()
                    //                    nextVC!.applyShrinkModifiers()
                }
                state = nextState
                hero.replaceViewController(with: nextVC!)
            } else {
                let progress = abs(translateX / view.bounds.width)
                Hero.shared.update(progress)
                if state == .slidingLeft, let nextVC = nextVC {
                    Hero.shared.apply(modifiers: [.translate(x: view.bounds.width - translateX)], to: nextVC.view)
                } else {
                    Hero.shared.apply(modifiers: [.translate(x: translateX)], to: view)
                }
            }
        default:
            let progress = (translateX + velocityX) / view.bounds.width
            if (progress < 0) == (state == .slidingLeft) && abs(progress) > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            state = .normal
        }
    }
    
    func heroWillStartAnimatingTo(viewController: UIViewController) {
        if !(viewController is OnboardingVC) {
            view.hero.modifiers = [.ignoreSubviewModifiers(recursive: true)]
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let nav = UINavigationController(rootViewController: ProfileVC())
        self.present(nav, animated: true, completion: nil)
    }
}



class PageOneVC: UIViewController {
    
    var label = UILabel()
    
    var imageViewOne: UIImageView!
    var imageViewTwo: UIImageView!
    var imageViewThree: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Create your own art painting gallery with your own by hight quality pictures."
        label.sizeToFit()
        label.textAlignment = .center
        
        imageViewOne = UIImageView(image: UIImage(named: "one"))
        imageViewTwo = UIImageView(image: UIImage(named: "two"))
        imageViewThree = UIImageView(image: UIImage(named: "four"))
        view.addSubview(label)
        view.addSubview(imageViewOne)
        view.addSubview(imageViewTwo)
        view.addSubview(imageViewThree)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, imageViewOne, imageViewTwo, imageViewThree, view) { (label, imageViewOne, imageViewTwo, imageViewThree, view) in
            
            label.top == view.top + 150
            label.centerX == view.centerX
            label.width == view.width - 60
            
            imageViewTwo.top == label.bottom + 150
            imageViewTwo.centerX == view.centerX
            imageViewTwo.height == 90
            imageViewTwo.width == 90
            
            imageViewOne.left == imageViewTwo.left + 93
            imageViewOne.height == 90
            imageViewOne.width == 90
            imageViewOne.centerY == imageViewTwo.centerY
            
            imageViewThree.right == imageViewTwo.right -  93
            imageViewThree.height == 90
            imageViewThree.width == 90
            imageViewThree.centerY == imageViewTwo.centerY
        }
        
        let shadowView = CALayer()
        shadowView.bounds = CGRect(x: 0, y: 0, width: 90, height: 90)
        shadowView.backgroundColor = UIColor(white: 0.6, alpha: 0.5).cgColor
        
        imageViewOne.layer.addSublayer(shadowView)
            
            //UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
       // shadowView.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        
//        imageViewOne.addSubview(shadowView)
//        imageViewTwo.addSubview(shadowView)
//        imageViewThree.addSubview(shadowView)
    }
}

class PageTwoVC: UIViewController {
    
    var label: UILabel!
    
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel(frame: CGRect(x: 0, y: 120, width: view.frame.width - 50, height: 60))
        label.center.x = view.center.x
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.text = "Add details for the piece."
        label.textAlignment = .center
        
        imageView = UIImageView(image: UIImage(named: "one"))
        
        view.addSubview(label)
        view.addSubview(imageView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constrain(imageView, view) { (imageView, view) in
            imageView.center == view.center
            imageView.height == 90
            imageView.width == 90
        }
    }
}

class PageThreeVC: UIViewController {
    
    struct Data {
        var title: String
        var image: UIImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        self.hero.isEnabled = true
    }
}
