import SwiftUI

struct LogInView: View {
    @StateObject var vm: LogInViewModel
    @Binding var show: Bool
    let authManager: AuthenticationManager
    
    init(authManager: AuthenticationManager, show: Binding<Bool>) {
        self._vm = StateObject(wrappedValue: LogInViewModel(authManager: authManager))
        self._show = show
        self.authManager = authManager
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
                SignUpView(authManager: authManager, show: $vm.showSignUp)
            }
        }
    }
}

#Preview {
    LogInView(authManager: AuthenticationManager(),
              show: .constant(false))
}

private extension LogInView {
    
    var signIn : some View {
        VStack(spacing: 20) {
            LogInButton(text: "Sign in",
                        backgroundColor: .white,
                        textColor: Color.logInBackground){
                vm.signIn()
                
                if vm.alertItem == nil && vm.succesful {
                    dismiss()
                }
            }
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
