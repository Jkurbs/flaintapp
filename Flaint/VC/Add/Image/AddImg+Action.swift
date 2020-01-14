//
//  AddImg+Action.swift
//  Flaint
//
//  Created by Kerby Jean on 9/10/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftKeychainWrapper

extension AddImageVC {
    
    @objc func crop() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 0.0
            self.editView.alpha = 1.0
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = false
    }
    
    @objc func cancelCrop() {
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1.0
            self.editView.alpha = 0.0
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
    }
    
    @objc func doneCrop() {
        let croppedImage = editView.getCroppedImage()
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1.0
            self.editView.alpha = 0.0
        }
        self.imageView.layer.zPosition = 1
        self.imageView.image = croppedImage
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
    }
    
    @objc func cancel() {
        if self.imageView.image != nil {
            alert()
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func nextStep() {
                
        self.navigationItem.addActivityIndicator()
        let vc = AddInfoVC()
        
        let userId = Auth.auth().currentUser!.uid
        
        vc.prediction = self.prediction
        vc.artImage = self.imageView.image
        vc.styles = self.classifications
        
        // Save image
        let imgData = self.imageView.image!.jpegData(compressionQuality: 1.0)!
        
        let imgUID = NSUUID().uuidString
        vc.artId = imgUID
        let ref = DataService.shared.RefStorage.child("Arts").child(userId).child(imgUID)
        self.ref = ref
        
        DispatchQueue.global(qos: .background).async {
            DataService.shared.saveImg(ref, userId, imgData, { (url, success, error) in
                if !success {
                    print("error:", error!.localizedDescription)
                } else {
                    vc.imgUrl = url!
                }
            })
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.navigationItem.removeActivityIndicator("Next", #selector(self.nextStep))
    }

    
    @objc func photoLibrary(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    
    // MARK: - ALert
    
    func alert() {
        let alert = UIAlertController(title: "", message: "Are you sure want to cancel?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            if self.ref != nil {
                self.ref.delete { (error) in
                    if error != nil {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
