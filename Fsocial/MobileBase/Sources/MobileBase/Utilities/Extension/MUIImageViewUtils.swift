//
//  UIImageViewUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import UIKit
import SDWebImage

public extension UIImageView {
    func loadImage(_ imagePath: String, size: CGFloat) {
        if let url = URL(string: imagePath) {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed)
        }
    }
    
    func loadImageAndResize(_ imageURL: URL?, completed: SDExternalCompletionBlock?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.sd_setImage(with: imageURL, placeholderImage: nil, options: .scaleDownLargeImages, completed: completed)
    }
    
    func loadImageWithComplete(_ imageURL: URL?, placeholderImage: String? = nil, completed: SDExternalCompletionBlock?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let placeholder = placeholderImage {
            self.sd_setImage(with: imageURL, placeholderImage: UIImage(named: placeholder), completed: completed)
        } else {
            self.sd_setImage(with: imageURL, completed: completed)
        }
    }
    
    func loadImage(fromURL urlString: String?, placeholderImage: String? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let placeholder = placeholderImage {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: placeholder))
        } else {
            self.sd_setImage(with: url)
        }
    }
    
    func loadImage(urlString: String?, placeholder: UIImage? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }

    func setThumbImage(path: String) {
        setThumbImage(path: path, width: self.bounds.width)
    }

    func setThumbImage(path: String, width: CGFloat) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let url = URL(string: path) else {
            return
        }
        sd_setImage(with: url, placeholderImage: nil, options: .retryFailed)
    }
    func changeColorImage(_ color: UIColor, with renderMode: UIImage.RenderingMode = .alwaysTemplate) {
        guard let newImage = image?.withRenderingMode(renderMode) else { return }
        image = newImage
        tintColor = color
    }
    
   
 
    func generateQRCode(from string: String, completion: (() -> (Void))? = nil){
        DispatchQueue.global().async {
            let data = string.data(using: .ascii)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)

                if let output = filter.outputImage?.transformed(by: transform) {
                    DispatchQueue.main.async {
                        self.image = UIImage(ciImage: output)
                        completion?()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.image = nil
                    completion?()
                }
            }
        }
    }
}
