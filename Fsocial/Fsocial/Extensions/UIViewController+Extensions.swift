//
//  UIViewController+Extensions.swift
//  Fsocial
//
//  Created by Huy Tran on 14/8/24.
//

import Foundation
import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}

extension UIApplication {
    
    var activeWindow: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return activeWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 24
        } else {
            return statusBarFrame.height
        }
    }
}
