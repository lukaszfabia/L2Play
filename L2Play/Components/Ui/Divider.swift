//
//  Divider.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//

import SwiftUI

struct CustomDivider: View {
    var text: Text?
    
    var body: some View {
        HStack {
            VStack { Divider().background(Color.primary) }
            
            if let text = text {
                text
                    .foregroundColor(Color.primary)
                    .padding(.horizontal, 8)
                
                VStack { Divider().background(Color.primary) }
            }
        }
        .padding(.vertical, 8)
    }
}
