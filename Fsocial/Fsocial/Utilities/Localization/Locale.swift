//
//  Locale.swift
// Example
//
//  Created by ChungTV on 11/02/2022.
//

import Foundation

extension Locale {
    static var appCurrent: Locale {
        switch LocalizationService.shared.currentLanguage() {
        case .vietnamese:
            return Locale(identifier: "vi-VN")
        case .english:
            return Locale(identifier: "en-US")
        }
    }
}
