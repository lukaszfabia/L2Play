//
//  MessageBuble.swift
//  L2Play
//
//  Created by Lukasz Fabia on 05/12/2024.
//

import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    let author: Author
    
    var body: some View {
        HStack {
            if !isCurrentUser { UserImage(pic: author.profilePicture, w: 30, h: 30) }
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding()
                    .background(isCurrentUser ? Color.accentColor : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(12)
                    .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)
                
                Text(message.timestamp.formatTimestamp())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if isCurrentUser { UserImage(pic: author.profilePicture, w: 30, h: 30) }
            if !isCurrentUser { Spacer() }
        }
        .padding(.vertical, 4)
        .padding(isCurrentUser ? .leading : .trailing, 60)
    }
}

