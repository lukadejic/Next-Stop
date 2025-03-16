import SwiftUI

struct LogInView: View {
    @StateObject private var vm = LogInViewModel()
    
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    
    @Binding var show: Bool

    var body: some View {
        ZStack{
            if !vm.showSignUp {
                VStack{
                    Image("NextStopLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                    
                    authentication
                    
                    Spacer()
                    
                    VStack(spacing: 20){
                        signIn
                    }
                    
                    Spacer()
                }
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
                .overlay(alignment: .topLeading) {
                    Button{
                        withAnimation(.snappy) {
                            show.toggle()
                        }
                    }label: {
                        BackButton()
                            .padding(.horizontal)
                    }
                }
            }else{
                SignUpView(show: $vm.showSignUp)
            }
        }
    }
}

#Preview {
    LogInView(show: .constant(false))
}

private extension LogInView {
    
    var signIn : some View {
        VStack(spacing: 20){
            LogInButton(text: "Sign in",
                        backgroundColor: .white,
                        textColor: Color.logInBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            
            HStack{
                Text("Don't have an account?")
                    .foregroundStyle(.white)
                Button{
                    withAnimation(.snappy()) {
                        vm.showSignUp.toggle()
                    }
                }label: {
                    Text("Sign up")
                        .underline()
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    var authentication : some View {
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

        }
    }
}
