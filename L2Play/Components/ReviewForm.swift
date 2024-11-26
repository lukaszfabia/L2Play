//
//  ReviewForm.swift
//  ios
//
//  Created by Lukasz Fabia on 25/10/2024.
//


import SwiftUI

struct ReviewForm: View {
    @StateObject var reviewViewModel: ReviewViewModel
    @Binding var closeForm: Bool
    @State var review : String = ""
    @State var rating : Int = 0

    
    private let options = [1, 2, 3, 4, 5]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    
                    
                    Text("Remember to be honest and respectful and avoid using offensive language.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    
                    HStack {
                        TextEditor(text: $review)
                            .padding(16)
                            .frame(height: 250)
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
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.bottom)
                    
                    
                    Button(action: {
                        Task {
                            await reviewViewModel.addReview(content: review, rating: rating)
                            closeForm.toggle()
                        }
                    }){
                        HStack{
                            Image(systemName: "paperplane")
                            Text("Submit review")
                        }
                    }.padding()
                    .frame(maxWidth: 200)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Create Review")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
