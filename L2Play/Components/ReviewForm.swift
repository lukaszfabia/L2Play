//
//  ReviewForm.swift
//  ios
//
//  Created by Lukasz Fabia on 25/10/2024.
//


import SwiftUI

struct ReviewForm: View {
    @State var review : String = ""
    @State var rating : Int = 0
    
    
    let options = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Remember to be honest and respectful and avoid using offensive language.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack {
                    TextEditor(text: $review)
                        .padding(16)
                        .frame(height: 300)
                        .foregroundColor(.primary)
                        .lineSpacing(2)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .autocapitalization(.sentences)
                .disableAutocorrection(false)
                .padding(.top, 10)
                
                
                
                VStack(alignment: .leading) {
                    Text("Star rating (1-5)")
                        .font(.headline)
                    
                    
                    Text("Choose your rating for game.")
                        .foregroundStyle(.secondary)
                    
                    
                    HStack(spacing: 20) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                rating = option
                            }) {
                                Image(systemName: rating >= option ? "star.fill" : "star")
                                    .foregroundColor(rating >= option ? .yellow : .gray)
                                    .font(.title)
                            }
                            .padding(.vertical, 10)
                        }
                    }.frame(maxWidth: .infinity)

                    
                }
                .padding()
                .background(Color.primary.opacity(0.1))
                .cornerRadius(15)
                .padding(.bottom)
                
                
                Button(action: {
                    print("Sent")
                }){
                    HStack{
                        Image(systemName: "paperplane")
                        Text("Submit review")
                    }
                }.padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.indigo, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                
                // error Message
                
                Spacer()
            }
            .padding()
            .navigationTitle("Create Review")
        }
    }
}

#Preview {
    ReviewForm(review: "XD", rating: 2)
}
