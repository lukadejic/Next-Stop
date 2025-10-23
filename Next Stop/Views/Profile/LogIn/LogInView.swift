import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LogInView: View {
    @StateObject var vm: LogInViewModel
    @Binding var show: Bool
    let authManager: AuthenticationManager
    let userManager: UserManagerProtocol
    
    init(authManager: AuthenticationManager,
         userManager: UserManagerProtocol,
         show: Binding<Bool>) {
        self._vm = StateObject(wrappedValue: LogInViewModel(authManager: authManager, userManager: userManager))
        self._show = show
        self.authManager = authManager
        self.userManager = userManager
    }
    
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Image("NextStopLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                authentication
                
                Spacer()
                
                VStack(spacing: 20) {
                    signIn
                }

                Spacer()
            }
            .onTapGesture {
                isEmailFocused = false
                isPasswordFocused = false
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.logInBackground, .red],
                    startPoint: UnitPoint(x: 0.5, y: 0.5),
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .topLeading) {
                Button {
                    withAnimation(.snappy) {
                        show.toggle()
                    }
                } label: {
                    BackButton()
                        .padding(.horizontal)
                }
            }
            .alert(item: $vm.alertItem) { alert in
                Alert(title: alert.title,
                      message: alert.message,
                      dismissButton: alert.dismissButton)
            }
            .fullScreenCover(isPresented: $vm.showSignUp) {
                SignUpView(authManager: authManager,
                           userManager: userManager,
                           show: $vm.showSignUp)
            }
        }
    }
}

#Preview {
    LogInView(authManager: AuthenticationManager(),
              userManager: UserManager(),
              show: .constant(false))
}

private extension LogInView {
    
    var signIn : some View {
        VStack(spacing: 20) {
            LogInButton(text: "Sign in",
                        backgroundColor: .white,
                        textColor: Color.logInBackground){
                vm.signIn()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
                  
            GoogleSignInButton(
                viewModel: GoogleSignInButtonViewModel(
                    scheme: .light,
                    style: .wide,
                    state: .normal)) {
                        Task {
                            do {
                                try await vm.signInWithGoogle()
                                dismiss()
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                }
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top,10)
                    .padding(.horizontal, 30)
            
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
