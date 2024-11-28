//
//  BlockedPeople.swift
//  L2Play
//
//  Created by Lukasz Fabia on 10/10/2024.
//

import SwiftUI

struct BlockedPeopleView: View {
    let user : User
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Text("View all the users you have blocked. You can unblock them by clicking button.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }.padding()
//                VStack{
//                    ForEach(user.blockedUsers, id: \.id) { blocked in
//                        BlockedUserRow(user: blocked)
//                    }
//                }
                .padding(.top, 10)
                .navigationTitle("Blocked Users")
            }
        }
    }
}


#Preview {
    BlockedPeopleView(user: .dummy())
}
