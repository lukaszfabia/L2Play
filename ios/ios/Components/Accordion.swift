//
//  Accordion.swift
//  ios
//
//  Created by Lukasz Fabia on 21/10/2024.
//

import SwiftUI

struct AccordionView: View {
    @State private var isExpanded = false
    var summary: String = "Add summary"
    var details: [String] = ["add", "some", "details"]

    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(summary, isExpanded: $isExpanded){
                VStack(alignment: .leading) {
                    ForEach(details, id: \.self) {elem in
                        HStack{
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 5, height:5)
                            Text(elem)
                            Spacer()
                        }
                    }.listStyle(PlainListStyle())
                }
                .padding()
            }
            .padding()
            .background(.primary.opacity(0.1))
            .cornerRadius(10)
            .foregroundStyle(.primary)
            .animation(.easeInOut, value: isExpanded)
        }
        .padding()
    }
}

#Preview {
    AccordionView(summary: "Test", details: ["elem1", "elem12", "sdfjlhsdlf"])
}
