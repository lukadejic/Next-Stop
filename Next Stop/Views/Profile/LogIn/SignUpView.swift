import SwiftUI

struct SignUpView: View {
    @StateObject private var vm = LogInViewModel()
    @Binding var show : Bool
    
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    @FocusState var isUsernameFocued: Bool
    @FocusState var isConfirmPasswordFocused: Bool
    @State private var confirmPassword = ""
    @State private var username = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("NextStopLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                VStack(spacing: 30) {
                    AuthenticationField(text: $vm.email,
                                        image: "person.fill")
                    .overlay{
                        Text(!isEmailFocused && vm.email.isEmpty ? "Email" : "")
                            .allowsHitTesting(false)
                    }
                    .focused($isEmailFocused)
                    .foregroundStyle(.white)
                    
                    PasswordField(password: $vm.password)
                    .overlay{
                        Text(!isPasswordFocused && vm.password.isEmpty ? "Password" : "")
                            .allowsHitTesting(false)
                    }
                    .focused($isPasswordFocused)
                    .foregroundStyle(.white)
                    .id("passwordField")

                    PasswordField(password: $confirmPassword)
                    .overlay{
                        Text(!isConfirmPasswordFocused && confirmPassword.isEmpty ? "Confirm password" : "")
                            .allowsHitTesting(false)
                    }
                    .focused($isConfirmPasswordFocused)
                    .foregroundStyle(.white)
                    .id("ConfirmPasswordField")
                    
                    AuthenticationField(text: $username,
                                        image: "person.fill")
                    .overlay{
                        Text(!isUsernameFocued && username.isEmpty ? "Username" : "")
                            .allowsHitTesting(false)
                    }
                    .focused($isUsernameFocued)
                    .foregroundStyle(.white)
                }
                
                Spacer()
                
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
                
                Spacer()
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                isEmailFocused = false
                isPasswordFocused = false
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
            .toolbar{
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
