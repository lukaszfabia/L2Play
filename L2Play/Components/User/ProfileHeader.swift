//
//  ProfileHeader.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var provider: AuthViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ZStack {
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 105, height: 105)
                        .shadow(radius: 12)
                    
                    UserImage(pic: provider.user.profilePicture, w: 100, h: 100)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text(provider.user.firstName ?? "unknown")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                +
                Text(" \(provider.user.lastName ?? "user")")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                
                Text("Followers")
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
                +
                Text(34534.shorterNumber())
                    .bold()
                
                Text("Following")
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
                +
                Text(12412.shorterNumber())
                    .bold()
                
                if let res = provider.user.createdAt.getMonthAndYear() {
                    Text("Joined")
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    
                    +
                    Text(res)
                        .bold()
                }
            }
        }
    }
}
