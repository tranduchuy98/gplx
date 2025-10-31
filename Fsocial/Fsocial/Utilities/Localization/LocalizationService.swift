//
//  LocalizationService.swift
// Example
//
//  Created by ChungTV on 11/02/2022.
//

import Foundation

final class LocalizationService {
    
    private struct Keys {
        static let currentLanguage: String = "_eschool_localization_currentLanguage"
    }
    
    private static let baseLanguageName: String = "Base"
    
    private let baseLanguage: SupportedLanguage
    
    /// Initialization
    /// - Parameter baseLanguage: locale identifer for `Base` localization
    init(baseLanguage: SupportedLanguage) {
        self.baseLanguage = baseLanguage
    }
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    func availableLanguages(_ excludeBase: Bool = false) -> [SupportedLanguage] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if excludeBase, let indexOfBase = availableLanguages.firstIndex(of: LocalizationService.baseLanguageName) {
            availableLanguages.remove(at: indexOfBase)
        }
        
        return availableLanguages.compactMap({ lang in
            if lang == LocalizationService.baseLanguageName {
                return baseLanguage
            }
            
            return SupportedLanguage(rawValue: lang)
        }).sorted()
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    func currentLanguage() -> SupportedLanguage {
        if let currentLanguage = UserDefaults.standard.object(forKey: Keys.currentLanguage) as? String {
            return SupportedLanguage(rawValue: currentLanguage) ?? baseLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    func setCurrentLanguage(_ language: SupportedLanguage) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Keys.currentLanguage)
            NotificationCenter.default.post(name: .localizationServiceDidChangeCurrentLanguage,
                                            object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    func defaultLanguage(usePreferredLocalizations: Bool = false) -> SupportedLanguage {
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return baseLanguage
        }
        let availableLanguages: [String] = self.availableLanguages().map({ $0.rawValue })
        if usePreferredLocalizations, availableLanguages.contains(preferredLanguage) {
            return SupportedLanguage(rawValue: preferredLanguage) ?? baseLanguage
        }
        return baseLanguage
    }
    
    /**
     Resets the current language to the default
     */
    func resetCurrentLanguageToDefault(usePreferredLocalizations: Bool = true) {
        setCurrentLanguage(self.defaultLanguage(usePreferredLocalizations: usePreferredLocalizations))
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Parameter useLocalName: `true` if wants to display language name in its locale
     - Returns: The localized string.
     */
    func displayNameForLanguage(_ language: SupportedLanguage, useLocalName: Bool = false) -> String {
        let languageIdentifier: String = identifier(for: language)
        let currentLocaleIdentifier: String = useLocalName ? languageIdentifier : identifier(for: currentLanguage())
        let locale: NSLocale = NSLocale(localeIdentifier: currentLocaleIdentifier)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: languageIdentifier) {
            return displayName
        }
        return ""
    }
    
    private func identifier(for language: SupportedLanguage) -> String {
        language.rawValue
    }
}

extension LocalizationService {
    static let shared = LocalizationService(baseLanguage: .vietnamese)
}

extension Notification.Name {
    static let localizationServiceDidChangeCurrentLanguage = Notification.Name(rawValue: "_eschool_localizationServiceDidChangeCurrentLanguage")
}
