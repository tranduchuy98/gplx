//
//  UIViewUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation
import UIKit

public extension UIView {
    
    static var nibName: String {
        return String(describing: self)
    }

    static func loadNib(file: StaticString = #file, line: UInt = #line, bundle: Bundle = .main) -> Self {
        return loadNib(self, bundle: bundle)
    }
    
    internal static func loadNib<T: UIView>(_ viewType: T.Type, bundle: Bundle) -> T {
        guard let v = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
            fatalError("Can not load nib with name '\(nibName)'")
        }
        return v
    }
    
    var x: CGFloat {
        return frame.origin.x
    }

    var y: CGFloat {
        return frame.origin.y
    }
    
    @IBInspectable var fCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if newValue == -1 {
                layer.cornerRadius = frame.width < frame.height ? frame.width * 0.5 : frame.height * 0.5
            } else {
                layer.cornerRadius = newValue
            }
            clipsToBounds = true
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var fBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var fBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addSubviews(_ subViews: UIView...) {
        for subView in subViews {
            addSubview(subView)
        }
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    enum ViewCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    func makeCorner(radius: CGFloat, corners: [ViewCorner]) {
        var corners = corners
        
        if corners.isEmpty {
            corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        }
        
        let maskedCorners = corners.map { corner -> CACornerMask in
            switch corner {
            case .topLeft:
                return .layerMinXMinYCorner
            case .topRight:
                return .layerMaxXMinYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            }
        }

        layer.maskedCorners = CACornerMask(maskedCorners)
        layer.cornerRadius = radius
    }
    
    func drawDashLine(lineWidth: CGFloat,color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = lineWidth
        caShapeLayer.lineDashPattern = [5, 5]
        let startPoint = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        let endPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let cgPath = CGMutablePath()
        let cgPoint = [startPoint, endPoint]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
}
