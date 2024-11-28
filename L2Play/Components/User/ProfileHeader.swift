//
//  ProfileHeader.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

struct ProfileHeaderView<FollowSection: View>: View {
    let user: User
    
    @ViewBuilder var followSection: () -> FollowSection
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ZStack {
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 105, height: 105)
                        .shadow(radius: 12)
                    
                    UserImage(pic: user.profilePicture, w: 100, h: 100)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text(user.firstName ?? "unknown")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                +
                Text(" \(user.lastName ?? "user")")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                
                Text("Followers")
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
                +
                Text(user.followers.count.shorterNumber())
                    .bold()
                
                Text("Following")
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
                +
                Text(user.following.count.shorterNumber())
                    .bold()
                
                if let res = user.createdAt.getMonthAndYear() {
                    Text("Joined")
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    
                    +
                    Text(res)
                        .bold()
                }
                
                Spacer()
                
                followSection()
            }
        }
    }
}
