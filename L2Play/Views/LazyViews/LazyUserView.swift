
//
//  LazyUserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 10/12/2024.
//

import SwiftUI

struct LazyUserView: View {
    let userID: String
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        Group {
            if let user = userViewModel.user {
                UserView(user: user)
            } else {
                ProgressView("Loading user")
                    .task {
                        await userViewModel.fetchUser(with: userID)
                    }
            }
        }
    }
}

