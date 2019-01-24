//
//  IconButton.swift
//  locollector
//
//  Created by ryo on 2019/01/20.
//  Copyright © 2019 rytkmt. All rights reserved.
//

import Foundation
import UIKit
class ImageButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let targetHeight = CGFloat(self.frame.height)
        let newImage = resizeImage(image: self.currentImage!, targetHeight: targetHeight)
        self.setImage(newImage, for: .normal)
    }
    
    fileprivate func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage {
        // Get current image size
        let size = image.size
        
        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
