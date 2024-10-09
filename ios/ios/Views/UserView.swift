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
        VStack {
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
            
            NavigationStack{
                HStack{
                    NavigationLink(destination: ForgotPasswordView()){
                        HStack{
                            Button(action: {
                            }) {
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
                        }
                        
                    }
                    
                    NavigationLink(destination: ForgotPasswordView()){
                        Button(action: {
                        }) {
                            Text("Friends")
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }.shadow(radius: 10)
                    }
                }.padding()
                CustomDivider()
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("Your new")
                            .font(.largeTitle)
                        GradientText(text: "Friends")
                    }
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    let url: URL = URL(string: "https://placebeard.it/250/250")!
    
    UserView(user: User(
        first_name: "Lukasz",
        last_name: "Fabia",
        email: "ufabia03@gmail.com",
        profile_picture: url,
        friends: [],
        friend_requests: [],
        created_at: Date()
    ))
}
