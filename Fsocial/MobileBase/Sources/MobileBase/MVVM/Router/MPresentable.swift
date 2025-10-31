//
//  Presentable.swift
//  MVVMCore
//
//  Created by Tran Hieu on 05/08/2024.
//

import UIKit

public protocol MPresentable: AnyObject {
    func toPresentable() -> UIViewController
}

extension UIViewController: MPresentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
