//
//  FetchImageOperation.swift
//  Flaint
//
//  Created by Kerby Jean on 3/17/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import Foundation
import SDWebImage


class FetchImageOperation: BlockOperation {
    
    private(set)var imageData: Data?
    var imageView: UIImageView
    var urlString: String
    
    
    init(imageView: UIImageView, urlString: String) {
        self.urlString = urlString
        self.imageView = imageView
        super.init()
    }
    
    override func main() {
        let myBlock: SDExternalCompletionBlock! = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageUrl: URL?) -> Void in
            if let img = image {
                self?.imageData = img.jpegData(compressionQuality: 1.0)
            }
        }
        guard let url = URL(string: urlString) else { return }
        self.imageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground, completed: myBlock)
    }
}
