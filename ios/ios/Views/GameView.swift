//
//  GameView.swift
//  ios
//
//  Created by Lukasz Fabia on 19/10/2024.
//

import SwiftUI

struct GameView: View {
    var game: Game
    
    @State var isPresentedReviewForm: Bool = false
    
    var body: some View {
        ScrollView {
            /// main image
            GalleryView(images: game.pictures)
            
            Spacer(minLength: 20)
            
            /// Game title and rating
            VStack(alignment: .center) {
                Text(game.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                HStack{
                    if let year = game.releaseYear {
                        Text(String(year))
                            .foregroundStyle(.gray)
                    }
                    Text(game.studio)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
            
            
            HStack(spacing: 20) {
                Button(action: {
                    print("Add to list tapped")
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.indigo)
                        .clipShape(Circle())
                        .shadow(color: .indigo.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                
                Divider()
                
                
                Button(action: {
                    print("Favorite tapped")
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }
            
            
            Spacer(minLength: 40)
            
            BentoBoxView(game: game)
            
            Spacer(minLength: 40)
            
            /// form to rate game or write review
            
            Button(action: {
                isPresentedReviewForm.toggle()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "doc.text")
                        .resizable()
                        .frame(width: 17, height: 17)
                    
                    Text("Write Review")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primary, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.horizontal, 40)
            
            
            
            if !game.reviews.isEmpty {
                VStack{
                    ForEach(game.reviews) { review in
                        ReviewCard(review: review)
                    }
                }.padding()
            }
            
        }
        .padding(.top)
        .sheet(isPresented: $isPresentedReviewForm){
            ReviewForm()
        }
    }
}


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
                    GradientText(text: "#\(game.popularity)", customFontSize: 34) // largeTitle
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
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.yellow)
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
                        Text("$\(String(format: "%.2f", price))")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    } else {
                        Text("Free")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
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
                    
                    Text(shorterNumber(game.community))
                        .font(.largeTitle)
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


#Preview{
    GameView(game: Game.dummy())
}
