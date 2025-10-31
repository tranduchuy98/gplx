//
//  UIImageUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import UIKit

public extension UIImage {
    
    static func alwaysTemplate(named name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }
    
    static func from(color: UIColor,
                     size: CGSize = CGSize(width: 1, height: 1),
                     cornerRadius: CGFloat = 0.0) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(color.cgColor)
        
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect,
                         cornerRadius: cornerRadius)
                .fill()
        } else {
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func alwaysTemplate() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func convertToGrayScale() -> UIImage {
        guard let currentCGImage = self.cgImage else { return self }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: kCIInputColorKey)
        
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        guard let outputImage = filter?.outputImage else { return self}
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            
            return processedImage
        }
        
        return self
    }
    
    func grayScaled() -> UIImage? {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        guard let output = filter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    /// Fix image orientaton to portrait up
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != .up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let ctx = CGContext(data: nil,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    func resizedImage(with rectSize: CGSize,
                      and maxSize: CGSize,
                      color: UIColor? = nil) -> UIImage? {
        let width = min(rectSize.width, maxSize.width)
        let height = min(rectSize.height, maxSize.height)
        let size = CGSize(width: width, height: height)
        return resizedImage(with: size, color: color)
    }
    
    func resizedImage(with rectSize: CGSize,
                      color: UIColor? = nil) -> UIImage? {
        let widthRatio = size.width / rectSize.width
        let heightRatio = size.height / rectSize.height
        let resizeRatio = max(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width / resizeRatio, height: size.height / resizeRatio)
        guard size != newSize else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        if let color = color {
            color.set()
        }
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resize(toMaxWidth widthInPixels: CGFloat) -> UIImage? {
        let scale = widthInPixels / size.width
        let height = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: widthInPixels, height: height))
        draw(in: CGRect(x: 0, y: 0, width: widthInPixels, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func withInset(_ insetDimen: CGFloat) -> UIImage? {
        return withInset(UIEdgeInsets(top: insetDimen,
                                      left: insetDimen,
                                      bottom: insetDimen,
                                      right: insetDimen))
    }
    
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)
        
        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)
        
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIImage {
    private static let maximumImageSize: Int = 7 * 1024 * 1024 // 7MB
    private static let maximumImageWidth: CGFloat = 1024
    
    convenience init?(base64String: String?) {
        guard let base64 = base64String,
              let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        self.init(data: data)
    }
    // Convert image to base64 string
    
    enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    
    func toBase64(format: ImageFormat) -> String? {
        var imageData: Data?
        
        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }
        
        return imageData?.base64EncodedString()
    }
    
    func toBase64(maxWidth: CGFloat = UIImage.maximumImageWidth,
                  maxSize: Int = UIImage.maximumImageSize) -> String {
        var image: UIImage? = self
        
        if image?.size.width ?? 0.0 > maxWidth {
            image = resize(toMaxWidth: maxWidth)
        }
        
        let compressed = image?.compress()
        
        return compressed?.base64EncodedString() ?? ""
    }
    
    func compress() -> Data? {
        guard let png = pngData() else {
            return nil
        }
        if png.count >= 0 {
            return png
        }
        guard let imageData = jpegData(compressionQuality: 1) else {
            return nil
        }
        return imageData
    }
}
