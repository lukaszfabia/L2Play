//
//  Carousel.swift
//  ios
//
//  Created by Lukasz Fabia on 18/11/2024.
//

import SwiftUI


struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var color: Color
    var title: String
    var subTitle: String
    var game: Game
    
    init(game: Game) {
        self.title = ""
        self.subTitle = ""
        self.game = game
        self.color = Self.randColor()
    }
    
    private static func randColor() -> Color {
        let colors: [Color] = [
            .red, .blue, .accentColor, .green, .yellow, .pink
        ]
        
        
        return colors[Int.random(in: 0..<colors.count - 1)]
    }
}

struct CustomPageSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item:MutableCollection, Item.Element: Identifiable {
    
    var showsIndicators: ScrollIndicatorVisibility = .hidden
    var showPagingControl: Bool = true
    var titleScrollSpeed: CGFloat = 1
    var spacing: CGFloat = 20
    var paginControlSpacing: CGFloat = 10
    
    @Binding var data: Item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    var body: some View {
        VStack(spacing: paginControlSpacing){
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geomtryProxy in
                                    content
                                        .offset(x: scrollOffset(geomtryProxy))
                                }
                            
                            content(item)
                        }.containerRelativeFrame(.horizontal)
                    }
                }.scrollTargetLayout()
            }.scrollIndicators(showsIndicators)
                .scrollTargetBehavior(.viewAligned)
        }
    }
    
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        
        return -minX * min(titleScrollSpeed, 1.0)
    }
}
