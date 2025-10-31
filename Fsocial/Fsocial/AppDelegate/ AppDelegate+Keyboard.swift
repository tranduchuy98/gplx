//
//   AppDelegate+Keyboard.swift
// Example
//
//  Created by Tran Hieu on 01/08/2024.
//

import UIKit
import IQKeyboardManagerSwift

extension AppDelegate {
    func configKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 36.0
        let disabled: [UIViewController.Type] = []
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(contentsOf: disabled)
       
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        
        IQKeyboardManager.shared.resignOnTouchOutside = true
        let disabledTouchOutsideClass: [UIViewController.Type] = []
        IQKeyboardManager.shared.disabledTouchResignedClasses.append(contentsOf: disabledTouchOutsideClass)
        
        IQKeyboardManager.shared.enableAutoToolbar = !UIDevice.isPad
        
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
}
