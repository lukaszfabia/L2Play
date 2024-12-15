//
//  StatsView.swift
//  L2Play
//
//  Created by Lukasz Fabia on 14/12/2024.
//

import SwiftUI
import Charts

protocol GameKey: Hashable {}

extension String: GameKey {}
extension GameState: GameKey {}

struct GameData<T: GameKey>: Identifiable, Equatable {
    let id: UUID = .init()
    let key: T
    let count: Int
    
    init(key: T, count: Int) {
        self.key = key
        self.count = count
    }
    
    static func toList(lst: [[T: Int]], max: Int? = nil) -> [GameData<T>] {
        let r = Array(
            lst.compactMap { dict in
                dict.map { GameData(key: $0.key, count: $0.value) }
            }
                .flatMap { $0 }
                .sorted { $0.count < $1.count }
        )
        
        if let max = max {
            return Array(r.prefix(max))
        }
        
        return r
    }
    
    static func toList(lst: [T: Int], max: Int? = nil) -> [GameData<T>] {
        let r =  lst.map {
            GameData(key: $0.key, count: $0.value)
        }.sorted{
            $0.count > $1.count
        }
        
        guard let max, r.count > max else {return r}
        
        return Array(r.prefix(upTo: max))
    }
    
}

struct Collection: Identifiable {
    let id: UUID = .init()
    let games: [GameWithState]
    let title: String
    let subtitle: String
    let state: GameState
}

struct StatsView: View {
    let stateData: [GameData<GameState>]
    let tagsData:  [GameData<String>]
    let currentUser: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if stateData.isEmpty || tagsData.isEmpty {
                    VStack(spacing: 10) {
                        Text("Add to your collection some games!")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        
                        NavigationLink(destination: ExploreGamesView(user: currentUser)) {
                            Text("And see some mysterious magic happen!")
                                .font(.headline)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    VStack(alignment: .center) {
                            Text("Current states of your games")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                                .padding(.top)
                                .multilineTextAlignment(.center)
                            
                            Chart(stateData) { item in
                                BarMark(
                                    x: .value("State", item.key.rawValue),
                                    y: .value("Count", item.count)
                                )
                                .foregroundStyle(by: .value("State", item.key.rawValue))
                                .cornerRadius(12)
                            }
                            .frame(height: 300)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding()

                            Text("Your most popular tags")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                                .padding(.top)
                                .multilineTextAlignment(.center)
                            
                            Chart(tagsData) { item in
                                BarMark(
                                    x: .value("Tag", item.key),
                                    y: .value("Count", item.count)
                                )
                                .foregroundStyle(by: .value("Tag", item.key))
                                .cornerRadius(12)
                            }
                            .frame(height: 300)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.1), Color.orange.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding()
                        }
                        .padding(.horizontal)
                }
                
            }
            .padding()
            .navigationTitle("Stats")
        }
    }
}
