import SwiftUI

struct SignUpView: View {
    @StateObject private var vm : SignUpViewModel
    
    @Binding var show : Bool
    
    init(authManager: AuthenticationProtocol,
         userManager: UserManagerProtocol ,
         show: Binding<Bool>) {
        _vm = StateObject(wrappedValue: SignUpViewModel(
            authManager: authManager,
            userManager: userManager))
        _show = show
    }
    
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    @FocusState var isUsernameFocued: Bool
    @FocusState var isConfirmPasswordFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    
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
        .alert(item: $vm.alertItem) { alert in
            Alert(title: alert.title,
                  message: alert.message,
                  dismissButton: alert.dismissButton)
        }
    }
}

#Preview {
    SignUpView(authManager: AuthenticationManager(),
               userManager: UserManager(),
               show: .constant(false))
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
            AuthenticationField(text: $vm.email,
                                image: "person.fill")
            .overlay{
                Text(!isEmailFocused && vm.email.isEmpty ? "Email" : "")
                    .allowsHitTesting(false)
            }
            .focused($isEmailFocused)
            .foregroundStyle(.white)
            .keyboardType(.emailAddress)
            
            PasswordField(password: $vm.password)
            .overlay{
                Text(!isPasswordFocused && vm.password.isEmpty ? "Password" : "")
                    .allowsHitTesting(false)
            }
            .focused($isPasswordFocused)
            .foregroundStyle(.white)

            PasswordField(password: $vm.confirmPassword)
            .overlay{
                Text(!isConfirmPasswordFocused && vm.confirmPassword.isEmpty ? "Confirm password" : "")
                    .allowsHitTesting(false)
            }
            .focused($isConfirmPasswordFocused)
            .foregroundStyle(.white)
            
            AuthenticationField(text: $vm.username,
                                image: "person.fill")
            .overlay{
                Text(!isUsernameFocued && vm.username.isEmpty ? "Username" : "")
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
                        textColor: Color.logInBackground){
                Task{
                    do{
                        try await vm.signUp()
                        
                        if vm.succesful {
                            dismiss()
                        }
                        
                    }catch{
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
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
