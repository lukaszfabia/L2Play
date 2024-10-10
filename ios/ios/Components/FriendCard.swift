import SwiftUI

struct FriendCard: View {
    var friend: User

    var body: some View {
        NavigationLink(destination: ReadOnlyUserView(user: friend)) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 6)

                    AsyncImage(url: friend.profile_picture) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 75, height: 75)
                    }
                }
                
                HStack {
                    Text(friend.first_name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(friend.last_name)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()

            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}

#Preview {
    FriendCard(friend: User.dummy())
}
