//
//  UserView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI


struct UserView: View {
    @EnvironmentObject private var provider: AuthViewModel // for me
    @StateObject private var userViewModel: UserViewModel
    
    @State private var favs: [Item] = []
    @State private var reviews: [Review] = []
    
    @State private var isSettingsPresented = false
    
    @State private var stateData: [GameData<GameState>] = []
    @State private var tagsData: [GameData<String>] = []
    
    @State private var collection: [Collection] = []
    @State private var planned: [GameWithState] = []
    @State private var playing: [GameWithState] = []
    @State private var completed: [GameWithState] = []
    @State private var dropped: [GameWithState] = []
    
    
    init(user: User?) {
        self._userViewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }
    
    private var currentUser: User {
        userViewModel.user ?? provider.user
    }
    
    private var isReadOnly: Bool {
        userViewModel.user != provider.user
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if userViewModel.isLoading {
                    LoadingView()
                } else {
                    profile
                }
            }
            .task {
                guard !userViewModel.isLoading else { return }
                await loadData()
            }
        }
    }
    
    private var profile: some View {
        TabView {
            main
            StatsView(stateData: stateData, tagsData: tagsData, currentUser: currentUser)
            PlaylistView(userViewModel: userViewModel, collection: collection)
            ReviewsView(reviews: $reviews)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(isSettingsPresented: $isSettingsPresented)
        }
        .toolbar {
            if !isReadOnly {
                authUserMenu
            } else {
                readonlyUserMenu
            }
        }
    }
    
    private var main: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ProfileHeaderView(user: currentUser, actionSection: actionButtons)
                
                VStack(alignment: .center) {
                    if isReadOnly {
                        if currentUser.hasBlocked(provider.user.id) {
                            youreBlocked()
                        } else if provider.user.hasBlocked(currentUser.id) {
                            youBlockedUser()
                        }
                    }
                }
                
                
                if favs.isEmpty {
                    Text("No favourites yet.")
                        .foregroundStyle(.secondary)
                } else {
                    
                    HStack {
                        Text("Favourites")
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                        
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.accent)
                            .multilineTextAlignment(.leading)
                    }
                    .font(.largeTitle)
                    
                    CustomPageSlider(data: $favs) { $item in
                        NavigationLink(destination: LazyGameView(gameID: item.game.gameID, userViewModel: userViewModel)) {
                            FavoriteGamesRow(game: item.game)
                        }
                    } titleContent: { _ in }
                        .safeAreaPadding([.horizontal, .vertical], 10)
                }
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
    
    
    private var authUserMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { isSettingsPresented.toggle() }) {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
    }
    
    private var readonlyUserMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {
                    // init new or take existing chat
                }) {
                    Label("Send Message", systemImage: "paperplane.fill")
                }
                
                Button(role: .destructive, action: handleBlockUser) {
                    Label(provider.user.hasBlocked(currentUser.id) ? "Unblock" : "Block \(currentUser.firstName ?? "User")", systemImage: "hand.raised.fill")
                        .foregroundColor(.red)
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private func handleBlockUser() {
        Task {
            await provider.toogleBlockUser(currentUser)
            
            if provider.errorMessage != nil {
                HapticManager.shared.generateErrorFeedback()
            } else {
                HapticManager.shared.generateSuccessFeedback()
            }
        }
    }
    
    private func youBlockedUser() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("whoisblocked0".localized(with: currentUser.fullName()))
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("whoisblocked1".localized(with: currentUser.fullName()))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: BlockedPeopleView()) {
                    Text("Your blocked users")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.1))
        )
        .padding(.vertical, 8)
    }
    
    private func youreBlocked() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("You're blocked.")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("iamblocked".localized(with: currentUser.firstName ?? ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.1))
        )
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func actionButtons() -> some View {
        if isReadOnly && !provider.user.hasBlocked(currentUser.id) {
            HStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    Task {
                        await provider.followUser(currentUser)
                    }
                }) {
                    Text(provider.user.isFollowing(currentUser.id) ? "Unfollow" : "Follow")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 150, height: 40)
                .background(provider.user.isFollowing(currentUser.id) ? Color.red : Color.accentColor)
                .cornerRadius(20)
                .disabled(currentUser.hasBlocked(provider.user.id))
            }
            .padding([.vertical, .horizontal], 5)
        }
    }
    
    
    private func loadData() async {
        guard !currentUser.games.isEmpty else {return}
        
        self.reviews = await userViewModel.fetchReviewsForUser(user: currentUser)
        let games = await userViewModel.fetchGames(ids: currentUser.games.map { $0.gameID })
        
        stateData = GameData<GameState>.toList(lst: currentUser.computeGameStateAndCard())
        tagsData = GameData<String>.toList(lst: currentUser.computeFavoriteTags(games: games), max: 4)
        
        if let dict = userViewModel.user?.splitByState() {
            self.planned = dict[.planned] ?? []
            self.playing = dict[.playing] ?? []
            self.completed = dict[.completed] ?? []
            self.dropped = dict[.dropped] ?? []
            self.favs = dict[.favorite]?.map { game in Item(game: game) } ?? []
            
            self.collection = [
                Collection(
                    games: self.planned,
                    title: "Upcoming Adventures".localized(),
                    subtitle: "Games you're excited to start.".localized(),
                    state: .planned),
                
                Collection(
                    games: self.playing,
                    title: "Current Quests".localized(),
                    subtitle: "Games you're immersed in right now.".localized(),
                    state: .playing
                ),
                Collection(
                    games: self.completed,
                    title: "Victorious Journeys".localized(),
                    subtitle: "Games you've conquered.".localized(),
                    state: .completed),
                Collection(
                    games: self.dropped,
                    title: "Paused Dreams".localized(),
                    subtitle: "Games you've set aside for now.".localized(),
                    state: .dropped)
            ]
        }
    }
    
}


