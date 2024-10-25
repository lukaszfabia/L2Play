//
//  GalleryView.swift
//  ios
//
//  Created by Lukasz Fabia on 25/10/2024.
//

import SwiftUI

struct GalleryView: View {
    var images: [URL]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(images, id: \.self) { imageName in
                    AsyncImage(url: imageName) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 400)
                            .clipped()
                            .cornerRadius(30)
                        
                    } placeholder: {
                        ProgressView()
                            .frame(width: 300, height: 400)
                            .cornerRadius(30)
                        
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(width: 300, height: 400)
            .cornerRadius(30)
        }
    }
}
