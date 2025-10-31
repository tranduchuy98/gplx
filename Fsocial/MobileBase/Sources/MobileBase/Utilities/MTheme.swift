//
//  Theme.swift
// Example
//
//  Created by ChungTV on 15/02/2022.
//  Copyright © 2022 FTech AI. All rights reserved.
//

import UIKit

@propertyWrapper
struct MTheme {
    
    let light: UIColor
    let dark: UIColor
    
    var wrappedValue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return self.dark
                } else {
                    return self.light
                }
            }
        } else {
            return MThemeManager.isDarkModeSelected ? dark : light
        }
    }
}

enum MThemeManager {
    static var isDarkModeSelected: Bool = false
}
