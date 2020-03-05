//
//  Recorder.swift
//  Flaint
//
//  Created by Kerby Jean on 5/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import ReplayKit
import Cartography


class RecorderView: UIView {
    
    weak var viewController: ProfileVC!
    let recorder = RPScreenRecorder.shared()

//    var recordView: UIView!
    var pulseAnimation: CABasicAnimation!
    
    var seconds = 15
    var timer = Timer()
    var timerLabel: UILabel!
    
    lazy var recordView: UIView = {
        let view = UIView()
        view.clipsToBounds = true 
        view.backgroundColor = .red
        return view
    }()
    
    var doneButton: UIBarButtonItem!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .backgroundColor
        
        recorder.isMicrophoneEnabled = false
        
        timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.textColor = .darkText
        timerLabel.font = UIFont.systemFont(ofSize: 15)
        timerLabel.text = "15 sec"
        addSubview(timerLabel)
        
        pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        recordView.layer.add(pulseAnimation, forKey: "animateOpacity")
        
        addSubview(recordView)
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(stopRecording))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timerLabel.frame = CGRect(x: 190/2, y: 15, width: 0, height: 0)
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.sizeToFit()
        
        recordView.frame = CGRect(x: 85, y: 0, width: 7, height: 7)
        recordView.center.y = timerLabel.center.y
        recordView.layer.cornerRadius = recordView.frame.height/2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startRecording(complete: @escaping () -> ()) {
     
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        
        self.isHidden = false
        
        recorder.startRecording {  (error) in
            guard error == nil else {
                print("There was an error starting the recording.")
                return
            }
            
            DispatchQueue.main.async {
                self.viewController.navigationItem.titleView = self
                self.recordView.layer.add(self.pulseAnimation, forKey: "animateOpacity")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                self.viewController.navigationItem.rightBarButtonItem = self.doneButton
                self.viewController.navigationController?.isToolbarHidden = true
            }
        }
    }
    
    
    @objc func stopRecording() {
        
        print("STOP")
        
        
        recorder.stopRecording {(preview, error) in
            
            
            
            
            
            print("STOP")

            print("done")

            guard preview != nil else {
                print("Preview controller is not available.")
                return
            }
            
            print("STOP")

            DispatchQueue.main.async {
                self.isHidden = true
//                self.viewController.navigationItem.rightBarButtonItem = self.viewController.menuButton
                self.viewController.navigationController?.isToolbarHidden = false
            }
            
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                self.recorder.discardRecording(handler: { () -> Void in
                    DispatchQueue.main.async {
                        self.viewController.showMessage("Recording successfully deleted.", type: .success)
                        self.timerLabel.text = "10 sec"
                        self.seconds = 15
                    }
                })
            })
            
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) -> Void in
                preview?.previewControllerDelegate = self
                self.viewController.present(preview!, animated: true, completion: nil)
            })
            
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            self.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "\(seconds) sec"
        if seconds == 0 {
            timer.invalidate()
            stopRecording()
        }
    }
}

extension RecorderView : RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
}
