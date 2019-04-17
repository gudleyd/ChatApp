//
//  ImageCell.swift
//  ChatApp
//
//  Created by Иван Лебедев on 16/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    static func cropCenter(image: UIImage) -> UIImage {
        if let cgimage = image.cgImage {
            let side = min(cgimage.width, cgimage.height)
            let rect = CGRect(x: 0, y: 0, width: side, height: side)
            if let cropped = cgimage.cropping(to: rect) {
                let newImage = UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
                return newImage
            }
        }
        return image
    }
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image: UIImage) {
        self.imageView.image = UIImage.cropCenter(image: image)
    }
}
