//
//  iosApp.swift
//  ios
//
//  Created by Lukasz Fabia on 26/09/2024.
//

import SwiftUI

@main
struct iosApp: App {
    @StateObject private var provider = AuthProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(provider)
        }
    }
}
