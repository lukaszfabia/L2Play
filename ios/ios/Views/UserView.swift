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
                ScrollView{
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
                            
                            AsyncImage(url: user.profilePicture) { image in
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
                        Text(user.firstName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        +
                        Text(" \(user.lastName)")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                        
                        Text("Followers: ")
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                        +
                        Text("12")
                            .bold()
                        
                        Text("Following: ")
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                        +
                        Text("120 341 341")
                            .bold()
                        
                        Text("Joined: ")
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                        +
                        Text(timeAgoSinceDateSimple(user.createdAt))
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
                                .primary
                            )
                            .cornerRadius(10)
                    )
                    
                    NavigationLink(destination: FriendsView()) {
                        Text("Games")
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(.indigo)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    
                }.padding()
                
                CustomDivider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Your")
                            .font(.largeTitle)
                            .fontWeight(.light)
                        GradientText(text: "Favourites")
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(user.favGames, id: \.id) { game in
                                GameCard(game: game)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        GradientText(text: "Playlist")
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(user.playlist, id: \.id) { game in
                                GameCard(game: game)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    UserView(user: User.dummy())
}
