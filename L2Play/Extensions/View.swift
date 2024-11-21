//
//  View.swift
//  ios
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation
import SwiftUI


extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        

        return root
    }
}
