//
//  Shape.swift
//  ios
//
//  Created by Lukasz Fabia on 17/11/2024.
//

import SwiftUI

struct CustomCorners: Shape {
    var cornerRadii: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)
        )
        return Path(path.cgPath)
    }
}
