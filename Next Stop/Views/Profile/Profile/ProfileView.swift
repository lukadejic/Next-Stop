import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var showLoginView = false
    let authManager : AuthenticationManager
    let userManager: UserManagerProtocol
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        
                        if vm.user == nil {
                            login
                        } else {
                            LogedInProfileView(vm: vm)
                        }
                        Spacer()
                    }
                }
                .onAppear {
                    vm.getAuthenticatedUser()
                    vm.loadAuthProviders()
                }
                .fullScreenCover(isPresented: $showLoginView) {
                    LogInView(authManager: authManager,
                              userManager: userManager,
                              show: $showLoginView)
                }
                
            }
            .navigationTitle("Profile")
        }
        .alert(item: $vm.alertItem) { alert in
            Alert(title: alert.title,
                  message: alert.message,
                  dismissButton: alert.dismissButton)
        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()),
                authManager: AuthenticationManager(),
                userManager: UserManager())
}

private extension ProfileView {
    var login: some View {
        VStack(alignment: .leading) {
            Text("Log in to start planning your next trip.")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.5))
                .padding(.top, 20)
            
            LogInButton(text: "Log in",
                        backgroundColor: .pink,
                        textColor: .white) {
                withAnimation(.snappy) {
                    showLoginView.toggle()
                }
            }
        }
    }
}
