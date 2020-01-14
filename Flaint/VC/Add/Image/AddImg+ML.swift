////
////  AddImg+ML.swift
////  Flaint
////
////  Created by Kerby Jean on 9/10/19.
////  Copyright © 2019 Kerby Jean. All rights reserved.
////
//
//
//import UIKit
//import CoreML
//import Vision
//
//extension AddImageVC {
//    
//    /// - Tag: PerformRequests
//    func updateClassifications(for image: UIImage) {
//        
//        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
//        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
//            do {
//                try handler.perform([self.classificationRequest])
//            } catch {
//                /*
//                 This handler catches general image processing errors. The `classificationRequest`'s
//                 completion handler `processClassifications(_:error:)` catches errors specific
//                 to processing that request.
//                 */
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
//    }
//    
//    /// Updates the UI with the results of the classification.
//    /// - Tag: ProcessClassifications
//    func processClassifications(for request: VNRequest, error: Error?) {
//        DispatchQueue.main.async {
//            guard let results = request.results else {
//                return
//            }
//            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results as! [VNClassificationObservation]
//            
//            if classifications.isEmpty {
//                //                self.label.text = "Nothing recognized."
//            } else {
//                // Display top classifications ranked by confidence in the UI.
//                let topClassifications = classifications.prefix(2)
//                for classification in classifications {
//                    print("FIRST CLASSIFICATION")
//                    self.classifications.append(classification.identifier)
//                }
//                _ = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                self.prediction = classifications.first?.identifier
//            }
//        }
//    }
//}
