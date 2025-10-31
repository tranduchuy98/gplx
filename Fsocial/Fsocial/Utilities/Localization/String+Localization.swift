//
//  String+Localization.swift
// Example
//
//  Created by ChungTV on 11/02/2022.
//

import Foundation

extension String {
    func localized(_ bundle: Bundle? = nil) -> String {
        if let bundle = bundle {
            return TranslationService.shared.lookupTranslation(forKey: self, inTable: nil, bundle: bundle)
        } else {
            return TranslationService.shared.lookupTranslation(forKey: self, inTable: nil)
        }
    }
}
