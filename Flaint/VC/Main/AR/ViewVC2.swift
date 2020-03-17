////
////  ViewVC.swift
////  Flaint
////
////  Created by Kerby Jean on 5/18/19.
////  Copyright © 2019 Kerby Jean. All rights reserved.
////
//
//import UIKit
//import ARKit
//import Cartography
//
//class ViewVC: UIViewController {
//    
//   // MARK: IBOutlets
//    
//   @IBOutlet var sceneView: ARSCNView!
//   @IBOutlet weak var upperControlsView: UIView!
//    
//   // MARK: - UI Elements
//   
//   let coachingOverlay = ARCoachingOverlayView()
//      
//   /// The view controller that displays the status and "restart experience" UI.
//   lazy var statusViewController: StatusViewController = {
//    return children.lazy.compactMap({ $0 as? StatusViewController }).first!
//   }()
//    
//    
//    
//// MARK: - View Controller Life Cycle
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    sceneView.delegate = self
//    sceneView.session.delegate = self
//    
//    // Set up coaching overlay.
//    setupCoachingOverlay()
//
//    // Set up scene content.
//    sceneView.scene.rootNode.addChildNode(focusSquare)
//
//    // Hook up status view controller callback(s).
//    statusViewController.restartExperienceHandler = { [unowned self] in
//        self.restartExperience()
//    }
//    
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showVirtualObjectSelectionViewController))
//    // Set the delegate to ensure this gesture is only used when there are no virtual objects in the scene.
//    tapGesture.delegate = self
//    sceneView.addGestureRecognizer(tapGesture)
//}
//
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
////    var sceneView: ARSCNView!
////    var grids = [Grid]()
////    var scene: SCNScene?
////    var image: UIImage!
////
////    var artRoomScene = ArtRoomScene(create: true)
////
////    var rotateButton: UIButton!
////    var firstTimeView = FirsTimeView()
////    var geometry = SCNBox()
////
////    var sessionInfoLabel = UILabel()
////    var sessionInfoView: SessionInfoView!
////
////    override var prefersStatusBarHidden: Bool {
////        return true
////    }
////
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        view.backgroundColor = .white
////
////        sceneView = ARSCNView(frame: view.frame)
////        sceneView.delegate = self
////        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
////        sceneView.scene = artRoomScene
////        view.addSubview(sceneView)
////
////        let blurEffect = UIBlurEffect(style: .dark)
////
////        sessionInfoView = SessionInfoView(effect: blurEffect)
////        sessionInfoView.layer.cornerRadius = 5
////        sessionInfoView.clipsToBounds = true
////        sceneView.addSubview(sessionInfoView)
////
////        sessionInfoView.contentView.addSubview(sessionInfoLabel)
////        sessionInfoLabel.textAlignment = .center
////        sessionInfoLabel.numberOfLines = 5
////        sessionInfoLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
////        sessionInfoLabel.textColor = .white
////        sessionInfoLabel.text = "Initializing AR session"
////
////        var items = [UIBarButtonItem]()
////        self.rotateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
////        self.rotateButton.setImage(UIImage(named: "Rotation-30"), for: UIControl.State())
////        self.rotateButton.addTarget(self, action: #selector(rotate), for: .touchUpInside)
////        let rotateButton = UIBarButtonItem(customView: self.rotateButton)
////
////        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
////        items.append( UIBarButtonItem(image: UIImage(named: "More-30"), style: .done, target: self, action: nil))
////        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
////        items.append( UIBarButtonItem(image: UIImage(named: "Add-30"), style: .done, target: self, action: nil))
////        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
////        items.append( rotateButton)
////        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
////
////        self.navigationController?.toolbar.barTintColor = .backgroundColor
////        self.navigationController?.toolbarItems = items
////    }
////
////
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////
////        // Start the view's AR session with a configuration that uses the rear camera,
////        // device position and orientation tracking, and plane detection.
////        let configuration = ARWorldTrackingConfiguration()
////        configuration.planeDetection = .vertical
////        sceneView.session.run(configuration)
////
////        // Set a delegate to track the number of plane anchors for providing UI feedback.
////        sceneView.session.delegate = self
////
////        // Prevent the screen from being dimmed after a while as users will likely
////        // have long periods of interaction without touching the screen or buttons.
////        UIApplication.shared.isIdleTimerDisabled = true
////
////        // Show debug UI to view performance metrics (e.g. frames per second).
//////        sceneView.showsStatistics = true
////    }
////
////
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////
////        self.navigationController?.navigationBar.isHidden = true
////        self.navigationController?.isToolbarHidden = false
////        self.navigationController?.toolbar.barTintColor = .clear
////        self.navigationController?.toolbar.tintColor = .clear
////        self.navigationController?.toolbar.isTranslucent = true
////
////        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
////        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
////    }
////
////    override func viewWillDisappear(_ animated: Bool) {
////        super.viewWillDisappear(animated)
////        // Pause the view's session
////        sceneView.session.pause()
////    }
////
////
////
////
////    override func viewDidLayoutSubviews() {
////        super.viewDidLayoutSubviews()
////        constrain(sessionInfoView, sessionInfoLabel, view) { (sessionInfoView, sessionInfoLabel, view) in
////            sessionInfoView.top == view.top + 50
////            sessionInfoView.centerX == view.centerX
////            sessionInfoView.width == view.width - 150
////            sessionInfoView.height == 50
////
////            sessionInfoLabel.edges == sessionInfoView.edges
////        }
////        DispatchQueue.main.async {
////            self.sessionInfoView.contentView.layer.cornerRadius = 5.0
////        }
////    }
////
////
////    @objc func requestAccess() {
////        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
////            if granted {
////                self.allowAccess()
////            } else {
////                DispatchQueue.main.async {
////                    self.view.addSubview(self.firstTimeView)
////                    let alert = UIAlertController(title: "Camera access", message: "Go to your settings and allow Flaint to access your camera", preferredStyle: .alert)
////                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
////                    alert.addAction(action)
////                }
////            }
////        })
////    }
////
////    @objc func cancel() {
////       self.navigationController?.dismiss(animated: true, completion: nil)
////    }
////
////    @objc func allowAccess() {
////        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
////            let configuration = ARWorldTrackingConfiguration()
////            configuration.planeDetection = .vertical
////            sceneView.session.run(configuration)
////            UserDefaults.standard.set(false, forKey: "first_time_AR")
//////            DispatchQueue.main.async {
//////                self.navigationController?.isToolbarHidden = false
//////                self.navigationController?.isNavigationBarHidden = true
//////                self.firstTimeView.removeFromSuperview()
//////            }
////        } else {
////            view.addSubview(self.firstTimeView)
////        }
////    }
////
////
////    @objc func rotate() {
////        UIView.animate(withDuration: 0.2, animations: {
////            self.rotateButton.transform = CGAffineTransform(rotationAngle: .pi)
////        }) { (action) in
////            self.navigationController?.dismiss(animated: true, completion: nil)
////
////        }
////    }
////
////
////    @objc func done() {
////        self.dismiss(animated: true, completion: nil)
////    }
////
////    // MARK: - ARSessionDelegate
////
////    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
////        guard let frame = session.currentFrame else { return }
////        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
////    }
////
////    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
////        guard let frame = session.currentFrame else { return }
////        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
////    }
////
////    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
////        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
////    }
////
////
////    // MARK: - ARSessionObserver
////
////    func sessionWasInterrupted(_ session: ARSession) {
////        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
////        sessionInfoLabel.text = "Session was interrupted"
////    }
////
////    func sessionInterruptionEnded(_ session: ARSession) {
////        // Reset tracking and/or remove existing anchors if consistent tracking is required.
////        sessionInfoLabel.text = "Session interruption ended"
////        resetTracking()
////    }
////
////    func session(_ session: ARSession, didFailWithError error: Error) {
////        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
////        guard error is ARError else { return }
////
////        let errorWithInfo = error as NSError
////        let messages = [
////            errorWithInfo.localizedDescription,
////            errorWithInfo.localizedFailureReason,
////            errorWithInfo.localizedRecoverySuggestion
////        ]
////
////        // Remove optional error messages.
////        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
////
////        DispatchQueue.main.async {
////            // Present an alert informing about the error that has occurred.
////            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
////            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
////                alertController.dismiss(animated: true, completion: nil)
////                self.resetTracking()
////            }
////            alertController.addAction(restartAction)
////            self.present(alertController, animated: true, completion: nil)
////        }
////    }
////
////    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
////        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
////        let grid = Grid(anchor: planeAnchor)
////        self.grids.append(grid)
////        node.addChildNode(grid)
////    }
////
////    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
////        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
////        let grid = self.grids.filter { grid in
////            return grid.anchor.identifier == planeAnchor.identifier
////            }.first
////
////        guard let foundGrid = grid else {
////            return
////        }
////
////        foundGrid.update(anchor: planeAnchor)
////    }
////
////    @objc func tapped(gesture: UITapGestureRecognizer) {
////        // Get 2D position of touch event on screen
////        let touchPosition = gesture.location(in: sceneView)
////
////        // Translate those 2D points to 3D points using hitTest (existing plane)
////        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
////
////        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
////        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.firstIndex(where: { $0.anchor == anchor }) else {
////            return
////        }
////
////        addPainting(hitTest, grids[gridIndex])
////    }
////
////    func addPainting(_ hitResult: ARHitTestResult, _ grid: Grid)  {
////
////
//////        var desiredWidth = view.frame.width
//////        let desiredHeight = view.frame.height
//////        let imageHeight = img.size.height
//////        let imageWidth = img.size.width
//////
//////        let percent = imageWidth / desiredWidth / 3.5
//////
//////        if imageHeight > desiredHeight && imageHeight < 1300 ||  imageWidth > desiredWidth && imageWidth < 400 {
//////            desiredWidth = desiredWidth * percent
//////        } else {
//////            desiredWidth = desiredWidth * percent
//////        }
//////
//////        artRoomScene.boxnode.transform = SCNMatrix4(hitResult.anchor!.transform)
//////        artRoomScene.boxnode.eulerAngles = SCNVector3(artRoomScene.boxnode.eulerAngles.x + (-Float.pi / 2), artRoomScene.boxnode.eulerAngles.y, artRoomScene.boxnode.eulerAngles.z)
//////        artRoomScene.boxnode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
//////        grid.removeFromParentNode()
////    }
////
////    // MARK: - Private methods
////
////    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
////        // Update the UI to provide feedback on the state of the AR experience.
////        let message: String
////
////        switch trackingState {
////        case .normal where frame.anchors.isEmpty:
////            // No planes detected; provide instructions for this app's AR interactions.
////            message = "Find a nearby wall to get started"
////
////        case .notAvailable:
////            message = "Tracking unavailable"
////
////        case .limited(.excessiveMotion):
////            message = "Tracking limited - Move the device more slowly"
////
////        case .limited(.insufficientFeatures):
////            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions"
////
////        case .limited(.initializing):
////            message = "Initializing AR session"
////
////        default:
////            // No feedback needed when tracking is normal and planes are visible.
////            // (Nor when in unreachable limited-tracking states.)
////            message = ""
////
////        }
////        sessionInfoLabel.text = message
////        sessionInfoView.isHidden = message.isEmpty
////    }
////
////    private func resetTracking() {
////        let configuration = ARWorldTrackingConfiguration()
////        configuration.planeDetection = .vertical
////        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
////    }
//}



