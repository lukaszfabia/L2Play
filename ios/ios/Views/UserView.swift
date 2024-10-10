//
//  UserView.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


struct UserView: View {
    var user: User
    
    var body: some View {
        NavigationStack{
            
            /// profile card
            HStack{
                VStack(alignment: .leading){
                    ZStack{
                        Circle()
                            .fill(
                                Color.indigo
                            )
                            .frame(width: 105, height: 105)
                            .shadow(radius: 12)
                        
                        AsyncImage(url: user.profile_picture) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 12)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }.padding()
                
                
                VStack(alignment: .leading){
                    Text(user.first_name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    +
                    Text(" \(user.last_name)")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    
                    Text("Friends: ")
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    +
                    Text("12")
                        .bold()
                    Text("Joined ").foregroundStyle(.secondary)
                    +
                    Text(timeAgoSinceDateSimple(user.created_at))
                        .bold()
                }
            }
            
            /// buttons
            HStack{
                NavigationLink(destination: EditAccountView()){
                    HStack {
                        Text("Edit")
                            .padding()
                            .foregroundColor(Color.primary)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [.blue, .purple, .red]), startPoint: .leading, endPoint: .trailing), lineWidth: 2
                        )
                        .cornerRadius(10)
                )
                
                NavigationLink(destination: FriendsView()) {
                    Text("Friends")
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                
            }.padding()
            
            CustomDivider()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Your new")
                        .font(.largeTitle)
                    GradientText(text: "Friends")
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(user.friends, id: \.id) { friend in
                            FriendCard(friend: friend)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    UserView(user: User.dummy())
}
