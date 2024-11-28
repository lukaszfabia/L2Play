//
//  Fileds.swift
//  ios
//
//  Created by Lukasz Fabia on 22/10/2024.
//

import SwiftUI
import Combine

struct CustomFieldWithIcon: View {
    @Binding var acc: String
    let placeholder: String?
    var icon: String = ""
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }
            
            if isSecure {
                SecureField(placeholder ?? "", text: $acc)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
            } else {
                TextField(placeholder ?? "", text: $acc)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}



/// meduim otp field
struct OtpModifer: ViewModifier {

    @Binding var pin : String

    var textLimt = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }

    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 45, height: 45)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(10)
    }
}


struct OtpField: View{

    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    
    let f: () -> Void

    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""

    var body: some View {
            VStack {

                Text("Verify your Pin")
                    .font(.title2)
                    .fontWeight(.semibold)


                Text("Enter 4 digit code we'll text you on Email")
                    .font(.caption)
                    .fontWeight(.thin)
                    .padding(.top)

                HStack(spacing:15, content: {

                    TextField("", text: $pinOne)
                        .modifier(OtpModifer(pin:$pinOne))
                        .focused($pinFocusState, equals: .pinOne)

                    TextField("", text:  $pinTwo)
                        .modifier(OtpModifer(pin:$pinTwo))
                        .focused($pinFocusState, equals: .pinTwo)


                    TextField("", text:$pinThree)
                        .modifier(OtpModifer(pin:$pinThree))
                        .focused($pinFocusState, equals: .pinThree)


                    TextField("", text:$pinFour)
                        .modifier(OtpModifer(pin:$pinFour))
                        .focused($pinFocusState, equals: .pinFour)

                })
                .padding(.vertical)

                ButtonWithIcon(color: .accentColor, text: Text("Verify"), icon:"checkmark.circle") {
                    
                }
            }

    }
}
