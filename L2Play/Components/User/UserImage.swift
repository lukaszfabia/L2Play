//
//  UserImage.swift
//  L2Play
//
//  Created by Lukasz Fabia on 29/10/2024.
//

import SwiftUI

struct UserImage: View {
    let pic: URL?
    var w: CGFloat = 50
    var h: CGFloat = 50
    
    var body: some View {
        if let p = pic {
            AsyncImage(url: p) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: w, height: h)
                    .clipShape(Circle())
                    .shadow(radius: 12)
            } placeholder: {
                ProgressView()
                    .frame(width: w, height: h)
            }
        } else {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: w, height: h)
                .overlay(Text("No profile picture").foregroundColor(.gray))
        }
    }
}


struct LocalImage: View {
    let pic: UIImage
    var w: CGFloat = 50
    var h: CGFloat = 50
    
    var body : some View {
        Image(uiImage: pic)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: w, height: h)
            .clipShape(Circle())
            .shadow(radius: 12)
    }
}
