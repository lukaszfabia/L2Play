//
//  LoadingView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 28/11/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading")
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}
