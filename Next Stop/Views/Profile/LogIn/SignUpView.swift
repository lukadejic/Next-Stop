import SwiftUI

struct SignUpView: View {
    @Binding var show : Bool
    
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    @FocusState var isUsernameFocued: Bool
    @FocusState var isConfirmPasswordFocused: Bool
    
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("NextStopLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                authentication
                
                Spacer()
                
                signUp
                
                Spacer()
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                resetFocus()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.logInBackground, .red],
                    startPoint: UnitPoint(x: 0.5, y: 0.5),
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        withAnimation(.snappy) {
                            show.toggle()
                        }
                    }label: {
                        BackButton()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView(show: .constant(false))
}

private extension SignUpView {
    func resetFocus() {
        isEmailFocused = false
        isPasswordFocused = false
        isConfirmPasswordFocused = false
        isUsernameFocued = false
    }
    
    var authentication : some View {
        VStack(spacing: 30) {
            AuthenticationField(text: $email,
                                image: "person.fill")
            .overlay{
                Text(!isEmailFocused && email.isEmpty ? "Email" : "")
                    .allowsHitTesting(false)
            }
            .focused($isEmailFocused)
            .foregroundStyle(.white)
            
            PasswordField(password: $password)
            .overlay{
                Text(!isPasswordFocused && password.isEmpty ? "Password" : "")
                    .allowsHitTesting(false)
            }
            .focused($isPasswordFocused)
            .foregroundStyle(.white)

            PasswordField(password: $confirmPassword)
            .overlay{
                Text(!isConfirmPasswordFocused && confirmPassword.isEmpty ? "Confirm password" : "")
                    .allowsHitTesting(false)
            }
            .focused($isConfirmPasswordFocused)
            .foregroundStyle(.white)
            
            AuthenticationField(text: $username,
                                image: "person.fill")
            .overlay{
                Text(!isUsernameFocued && username.isEmpty ? "Username" : "")
                    .allowsHitTesting(false)
            }
            .focused($isUsernameFocued)
            .foregroundStyle(.white)
        }
    }
    
    var signUp : some View {
        VStack(spacing: 20){
            LogInButton(text: "Sign up",
                        backgroundColor: .white,
                        textColor: Color.logInBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            
            HStack{
                Text("Already have an account?")
                    .foregroundStyle(.white)
                Button{
                    withAnimation(.snappy) {
                        show.toggle()
                    }
                }label: {
                    Text("Sign in")
                        .underline()
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            }
        }

    }
}
