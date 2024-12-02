//
//  L2PlayApp.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import SwiftUI

@main
struct L2PlayApp: App {
    @StateObject private var provider = AuthViewModel()
    @StateObject private var accessibility = SettingsHandler()
    //    @StateObject private var translator = TranslatorService()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if provider.isLoading {
                LoadingView()
            }
            else {
                MainView()
                    .environmentObject(provider)
                    .environmentObject(accessibility)
                    .environment(\.locale, Locale(identifier: accessibility.language.rawValue))
                    .preferredColorScheme(accessibility.currentTheme())
            }
        }
    }
}
