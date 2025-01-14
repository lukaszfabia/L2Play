import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var provider: AuthViewModel
    @State private var firstName: String = ""
    @State private var lastName : String = ""
    @State private var password: String = ""
    @State private var email : String = ""
    
    @State private var isSubmitting : Bool = false
    @State private var isAuth : Bool = false
    
    private let details: [String] = [
        "At least 1 Big letter".localized(),
        "At least 1 Digit".localized(),
        "Minimum 6 characters".localized(),
        "At least 1 Special Sign".localized(),
    ]
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !provider.isLoading
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 6) {
                    VStack {
                        GoogleButton {
                            provider.continueWithGoogle(presenting: getRootViewController())
                        }
                        .accessibilityLabel(Text("Sign up with Google"))
                        
                        CustomDivider(text: Text("or".localized())).padding()
                        
                        Text("Get Started with Email".localized())
                            .font(.title2.bold())
                            .accessibilityLabel(Text("Get started with email"))
                    }
                    .padding()
                    
                    VStack {
                        Section {
                            CustomFieldWithIcon(acc: $firstName, placeholder: "Joe", icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                                .accessibilityLabel(Text("First name"))
                                .accessibilityHint(Text("Enter your first name"))
                            
                            CustomFieldWithIcon(acc: $lastName, placeholder: "Doe", icon: "person", isSecure: false)
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.sentences)
                                .accessibilityLabel(Text("Last name"))
                                .accessibilityHint(Text("Enter your last name"))
                            
                            CustomFieldWithIcon(acc: $email, placeholder: "joe.doe@example.com", icon: "envelope", isSecure: false)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .accessibilityLabel(Text("Email address"))
                                .accessibilityHint(Text("Enter your email address"))
                            
                            CustomFieldWithIcon(acc: $password, placeholder: "", icon: "lock", isSecure: true)
                                .autocorrectionDisabled()
                                .keyboardType(.alphabet)
                                .textInputAutocapitalization(.never)
                                .accessibilityLabel(Text("Password"))
                                .accessibilityHint(Text("Enter a strong password"))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        
                        AccordionView(summary: "How to make valid password?".localized(), details: details)
                            .accessibilityLabel(Text("Password requirements"))
                            .accessibilityHint(Text("Expand to see password requirements"))
                        
                        HStack {
                            NavigationLink(destination: LoginView()) {
                                Text("Already have an account?".localized())
                                    .foregroundStyle(.link)
                                    .fontWeight(.light)
                                    .font(.system(size: 12))
                                    .accessibilityLabel(Text("Login link"))
                                    .accessibilityHint(Text("Navigate to login screen"))
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .cornerRadius(20)
                    
                    Button(action: signup) {
                        HStack {
                            if provider.isLoading {
                                LoadingView()
                                    .accessibilityLabel(Text("Loading spinner"))
                            } else {
                                Image(systemName: "arrow.right")
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign Up".localized())
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .frame(width: 200)
                        .background(!isFormValid ? Color.gray : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .disabled(!isFormValid)
                        .accessibilityLabel(Text("Sign up button"))
                        .accessibilityHint(Text("Submit the registration form"))
                    }
                    
                    Text("By signing up, you agree to our Terms of Service and Privacy Policy.".localized())
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .accessibilityLabel(Text("Terms and privacy policy agreement"))
                        .accessibilityHint(Text("You agree to terms and privacy policy by signing up"))
                }
                .padding()
                .navigationTitle("Create Account".localized())
                .navigationDestination(isPresented: $isAuth) {
                    MainView()
                }
                .accessibilityLabel("SignUp")
            }
        }
    }
    
    private func signup() {
        provider.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
        isAuth = provider.isAuthenticated
        isAuth ? HapticManager.shared.generateSuccessFeedback() : HapticManager.shared.generateErrorFeedback()
    }
}
