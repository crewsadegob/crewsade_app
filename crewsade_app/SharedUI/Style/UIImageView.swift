//
//  ImageView.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 31/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import ImageIO

extension UIImageView {
    
    func setRoundedImage() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage? {
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        if let cgImg = image.cgImage {
            context?.draw(cgImg, in: imageRect)
            if let makeImg = context?.makeImage() {
                let imageRef = makeImg
                let newImage = UIImage(cgImage: imageRef)
                return newImage
            }
        }
        
        return UIImage()
    }
    
//    public func loadGif(name: String) {
//        DispatchQueue.global().async {
//            let image = UIImage.gif(name: name)
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//    }
//
//    @available(iOS 9.0, *)
//    public func loadGif(asset: String) {
//        DispatchQueue.global().async {
//            let image = UIImage.gif(asset: asset)
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//    }
    
}
