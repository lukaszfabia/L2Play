//
//  BentoLayout.swift
//  L2Play
//
//  Created by Lukasz Fabia on 25/11/2024.
//

import SwiftUI

struct BentoBoxView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .center) {
            /// popularity and studio
            HStack (spacing: 5){
                VStack(alignment: .leading) {
                    Text("Studio")
                        .font(.headline)
                    
                    Text(game.studio)
                        .font(.largeTitle)
                }
                .padding()
                .background(.primary.opacity(0.1))
                .cornerRadius(15)
                
                VStack(alignment: .trailing) {
                    Text("Popularity")
                        .font(.headline)
                    GradientText(text: Text("#\(game.popularity)"), customFontSize: .largeTitle)
                }
                .padding()
                .background(.primary.opacity(0.1))
                .cornerRadius(15)
            }
            
            /// price/community and tags
            HStack (spacing: 5){
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "star")
                        Text("Rating")
                            .font(.headline)
                    }
                    
                    Text(String(format: "%.2f", game.rating))
                        .font(.title.bold())
                        .foregroundStyle(.yellow.gradient)
                }
                .padding()
                .background(.primary.opacity(0.1))
                .cornerRadius(15)
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "dollarsign")
                        Text("Price")
                            .font(.headline)
                    }
                    
                    
                    if let price = game.price {
                        Text(String(format: "%.2f", price))
                            .font(.title)
                            .fontWeight(.semibold)
                    } else {
                        Text("Free")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green.gradient)
                    }
                }
                .padding()
                .background(.primary.opacity(0.1))
                .cornerRadius(15)
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "person.2")
                        Text("Community")
                            .font(.headline)
                    }
                    
                    Text(game.community.shorterNumber())
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(.primary.opacity(0.1))
                .cornerRadius(15)
            }
            
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "tag.fill")
                    Text("Tags")
                        .font(.headline)
                }
                FlowLayout(tags: game.tags)
            }
            .padding()
            .background(.primary.opacity(0.1))
            .cornerRadius(15)
            
            
            HStack{
                ForEach(game.platform, id: \.self) { p in Text(p)
                        .padding()
                        .background(.primary.opacity(0.1))
                        .cornerRadius(15)
                        .fontWeight(.semibold)
                        .font(.title2)
                    
                }
            }
        }
    }
    
}

