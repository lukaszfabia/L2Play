//
//  ChatView.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import SwiftUI

struct ChatView: View {
    var body : some View {
        NavigationStack {
            VStack {
                NavigationLink("Go to Page 1") {
                    VStack {
                        Text("This is Page 1")
                            .padding()
                        
                        // Zagnieżdżony NavigationLink
                        NavigationLink("Go to Page 2") {
                            Text("This is Page 2")
                                .padding()
                        }
                    }
                }
            }.navigationTitle("Chat")
        }
    }
}
