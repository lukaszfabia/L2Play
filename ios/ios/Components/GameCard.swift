import SwiftUI

struct GameCard: View {
    var game: Game

    var body: some View {
        NavigationLink(destination: GameView(game: game)) {
            HStack(spacing: 12) {
                ZStack {
                    AsyncImage(url: game.pictures[0]) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150*3/4, height: 200*3/4)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    } placeholder: {
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                        }
                        .frame(width: 150*3/4, height: 200*3/4)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                }
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    GameCard(game: Game.dummy())
}
