//
//  UserRow.swift
//  L2Play
//
//  Created by Lukasz Fabia on 29/10/2024.
//

import SwiftUI


struct UserRow<RowButton: View>: View {
    let user: User
    
    @ViewBuilder var button: (User) -> RowButton
    
    var body: some View {
        HStack {
            UserImage(pic: user.profilePicture)
            
            VStack(alignment: .leading) {
                Text(user.firstName ?? "Unknown")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(user.lastName ?? "User")
                    .foregroundColor(.secondary)
                    .font(.title3)
            }
            Spacer()
            
            button(user)
        }
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}
