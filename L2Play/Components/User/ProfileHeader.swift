//
//  ProfileHeader.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

import SwiftUI

struct ProfileHeaderView<ActionSection: View>: View {
    let user: User
    
    @ViewBuilder var actionSection: () -> ActionSection
    
    var body: some View {
        VStack(spacing: 5) {
            info()
            
            actionSection()
        }
    }
    
    
    private func info() -> some View {
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
                
                NavigationLink(destination: FollowView(user: user, title: .followers), label: {
                    Text("Followers: ")
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    +
                    Text(user.followers.count.shorterNumber())
                        .bold()
                }).buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: FollowView(user: user, title: .following), label: {
                    Text("Following: ")
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    +
                    Text(user.following.count.shorterNumber())
                        .bold()
                }).buttonStyle(PlainButtonStyle())
                
                if let res = user.createdAt.getMonthAndYear() {
                    Text("Joined: ")
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
