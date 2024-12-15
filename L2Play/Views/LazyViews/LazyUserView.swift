
//
//  LazyUserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 10/12/2024.
//

import SwiftUI

struct LazyUserView: View {
    let userID: String
    
    // you can provide clean object
    @ObservedObject var userViewModel: UserViewModel
    
    
    var body: some View {
        Group {
            if userViewModel.isLoading {
                LoadingView()
            } else {
                UserView(user: userViewModel.user)
            }
        }.task {
            await userViewModel.fetchUser(with: userID)
        }
    }
}

