//
//  SettingsHandler.swift
//  L2Play
//
//  Created by Lukasz Fabia on 01/12/2024.
//


import SwiftUI
import Foundation

enum Language: String {
    case english = "en"
    case polish = "pl"
}

class SettingsHandler: ObservableObject {
    @AppStorage("isDarkMode") var isDarkModeRaw: Bool?
    @AppStorage("language") var languageRaw: Language?
    
    var language: Language {
        get {
            return languageRaw ?? .english
        }
        set {
            languageRaw = newValue
        }
    }
    
    var isDarkMode: Bool {
        get {
            return isDarkModeRaw ?? false
        }
        set {
            isDarkModeRaw = newValue
        }
    }
    
    
    init() {
         let systemDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
         isDarkMode = isDarkModeRaw ?? systemDarkMode

         let systemLanguage = languageRaw?.rawValue ?? Locale.preferredLanguages.first ?? "en"
         language = Language(rawValue: systemLanguage) ?? .english
     }
    
    func currentTheme() -> ColorScheme {
        return isDarkMode ? .dark : .light
    }    
}

