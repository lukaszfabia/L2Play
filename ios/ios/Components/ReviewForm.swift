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
    
    
    let options = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Review creator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Here you can create your own review about our game.")
                .foregroundStyle(.gray)
                .font(.caption)
            
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
                Text("Rating (1-10)")
                    .font(.headline)
                
                
                Text("Choose your rating for game.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                ScrollView(.horizontal){
                HStack(spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                rating = option
                            }) {
                                Text("\(option)")
                            }
                            .buttonStyle(RadioButtonStyle(isSelected: rating == option))
                            .padding(.bottom, 10)
                        }
                    }
                }
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
        .padding(.top, 10)
    }
}

