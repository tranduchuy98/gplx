//
//  SupportedLanguage.swift
// Example
//
//  Created by ChungTV on 11/02/2022.
//

import Foundation

enum SupportedLanguage: String {
    case vietnamese = "vi"
    case english = "en"
}

extension SupportedLanguage {
    var isBase: Bool {
        false // no longer use Base localization
    }
    
    var bundlePath: String? {
        Bundle.main.path(forResource: isBase ? "Base" : rawValue, ofType: "lproj")
    }
}

/// For Collection `.sort(_:)`
extension SupportedLanguage: Comparable {
    private var sortIndex: Int {
        switch self {
        case .vietnamese:
            return 0
        case .english:
            return 1
        }
    }
    
    static func < (lhs: SupportedLanguage, rhs: SupportedLanguage) -> Bool {
        lhs.sortIndex < rhs.sortIndex
    }
}
