//
//  UserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

// TODO: add row with favourite game, playlist row, and reviews in componetnts, right now there is game card as a placeholder

struct UserView: View {
    var user: User
    // to remove
    private let favs: [Game] = [
        Game.dummy(), Game.dummy(), Game.dummy(), Game.dummy()
    ]
    
    @State private var selectedTab = 0
    @State private var isSettingsPresented = false
    @State private var isLoaded = false
    
    @State private var items: [Item] = [
        .init(color: .blue, title: "Ready for the Rift?", subTitle: "Dive into epic 5v5 battles and prove your dominance.", game: Game.dummy()),
        .init(color: .blue, title: "SwiftUI Mastery", subTitle: "Learn how to build iOS apps.", game: Game.dummy()),
        .init(color: .green, title: "Healthy Living", subTitle: "Tips for a balanced lifestyle.", game: Game.dummy()),
        .init(color: .orange, title: "Travel Tips", subTitle: "Make your journey unforgettable.", game: Game.dummy()),
        .init(color: .purple, title: "Gaming Guide", subTitle: "Level up your skills.", game: Game.dummy()),
        .init(color: .pink, title: "Creative Ideas", subTitle: "Unlock your inner artist.", game: Game.dummy()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    // users profile
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
                            Text(user.firstName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            +
                            Text(" \(user.lastName)")
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
                            
                            if let res = user.createdAt.getMonthAndYear() {
                                Text("Joined")
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.light)
                                
                                +
                                Text(res)
                                    .bold()
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    CustomDivider()
                    
                    Picker(selection: $selectedTab, label: Text("Menu")) {
                        Text("Favourites").tag(0)
                        Text("Playlist").tag(1)
                        Text("My Reviews").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedTab == 0 {
                        VStack (alignment: .leading) {
                            Text("Favourites")
                                .font(.largeTitle)
                                .fontWeight(.light)
                            
                            
                            // for tests
                            if !user.favGames.isEmpty {
                                Text("No favourites yet.")
                                    .foregroundStyle(.secondary)
                            }
                            
                            else {
                                CustomPageSlider(data: $items) { $item in
                                    NavigationLink(destination: GameView(game: item.game)){
                                        FavoriteGamesRow(game: item.game)
                                    }
                                } titleContent: {_ in }
                                .safeAreaPadding([.horizontal, .top, .bottom], 25)
                            }
                            
                        }
                    } else if selectedTab == 1 {
                        VStack(alignment: .leading) {
                            Text("Playlist")
                                .font(.largeTitle)
                                .fontWeight(.light)
                            
                            Text("No games planned to play.")
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                ForEach(user.playlist, id: \.id) { game in
                                    // create row here
                                    GameCard(game: game)
                                        .padding(.horizontal)
                                }
                            }
                            
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text("My Reviews")
                                .font(.largeTitle)
                                .fontWeight(.light)
                            
                            Text("No reviews yet.")
                                .foregroundStyle(.secondary)
                            
                
                            
                        }
                    }
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isSettingsPresented.toggle()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .sheet(isPresented: $isSettingsPresented) {
                    SettingsView()
                }
            }
        }
    }
}


#Preview {
    UserView(user: User.dummy())
        .environmentObject(AuthViewModel(
            isAuthenticated: true, user: User.dummy()
        ))
}
