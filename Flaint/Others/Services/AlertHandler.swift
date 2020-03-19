//
//  AlertHandler.swift
//  Flaint
//
//  Created by Kerby Jean on 7/28/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class AlertHandler {
    
    static func more(vc: ProfileVC, art: Art) {
        
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
    
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let deleteAlert = UIAlertController(title: "Are you sure you want to delete it from your gallery?", message: nil, preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                // Delete art
                if let userId = UserDefaults.standard.string(forKey: "userId") {
//                    DataService.shared.deleteArt(userId: userId, artId: art.id, { (success, error) in
//                        if !success {
//                            // Show error message
//                            vc.showMessage("Error while deleting", type: .error)
//                        } else {
//                            NotificationCenter.default.post(name: Notification.Name("fetchArts"), object: nil, userInfo: nil)
//                            // Show success message
//                            vc.showMessage("Successfully deleted", type: .success)
//                        }
//                    })
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteAlert.addAction(yesAction)
            deleteAlert.addAction(cancelAction)
            vc.present(deleteAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
