//
//  TranslationService.swift
// Example
//
//  Created by ChungTV on 11/02/2022.
//

import Foundation

final class TranslationService {
    
    static let shared = TranslationService()
    
    private(set) var bundle: Bundle!
    
    init() {
        reloadBundle()
    }
    
    func reloadBundle() {
        let lang = LocalizationService.shared.currentLanguage()
        if let bundlePath = lang.bundlePath {
            bundle = Bundle.init(path: bundlePath) ?? .main
        } else {
            bundle = Bundle.main
        }
    }
    
    func lookupTranslation(forKey key: String, inTable table: String?) -> String {
        return self.bundle.localizedString(forKey: key, value: nil, table: table)
    }
    
    func lookupTranslation(forKey key: String, inTable table: String?, bundle: Bundle) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: table)
    }
    
    func format(key: String, table: String, args: [CVarArg]) -> String {
        let format = lookupTranslation(forKey: key, inTable: table)
        return String(format: format, locale: Locale.appCurrent, arguments: args)
    }
}
