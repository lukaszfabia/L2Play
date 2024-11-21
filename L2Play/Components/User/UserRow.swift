//
//  UserRow.swift
//  L2Play
//
//  Created by Lukasz Fabia on 29/10/2024.
//

import SwiftUI

struct BlockedUserRow: View {
    let user: User
    let s: CGFloat = 75 // sizes
    var body : some View {
        HStack {
            NavigationLink(destination: UserView(user: user)) {
                UserImage(pic: user.profilePicture, w: s, h: s)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.firstName)
                            .foregroundStyle(.primary)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.lastName)
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
                
                Spacer()
            }
            
            
            ButtonWithIcon(color: .red, text: Text("Unblock"), action: {
                
            }, w: 100)
        }
        .background(Color(.systemGray6))
        .cornerRadius(40)
        .padding()
    }
}

#Preview {
    BlockedUserRow(user: .dummy())
}
